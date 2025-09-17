//
//  Handler+DominantColour.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//

import Accelerate
import Cocoa
import QuickLookThumbnailing
import SceneKit
import SwiftUI
import simd

@MainActor
public final class DominantColourHandler: ObservableObject {

  @Published var isBusy: Bool = false

  var imageFileURL: URL? = nil
  @Published var image: Thumbnail?

  let dimension: Int
  let tolerance = 10

  /// Storage for a matrix with `dimension * dimension` columns and `k` rows that stores the
  /// distances squared of each pixel color for each centroid.
  //  @ObservationIgnored
  var distances: UnsafeMutableBufferPointer<Float>?

  /// The number of centroids.
  @Published var k: Int = 2

  /// The SceneKit nodes that correspond to the values in the `centroids` array.
  var centroidNodes = [SCNNode]()
  /// The SceneKit scene that displays the RGB point cloud.
  @Published var scene = SCNScene()

  /// An array of source images.
  //    var sourceImages: [Thumbnail] = []

  @Published var sourceImage: CGImage? = nil
  @Published var quantizedImage: CGImage? = nil

  //  @ObservationIgnored
  var rgbImageFormat: vImage_CGImageFormat? = vImage_CGImageFormat(
    bitsPerComponent: 32,
    bitsPerPixel: 32 * 3,
    colorSpace: CGColorSpaceCreateDeviceRGB(),
    bitmapInfo: CGBitmapInfo(
      rawValue: kCGBitmapByteOrder32Host.rawValue
        | CGBitmapInfo.floatComponents.rawValue
        | CGImageAlphaInfo.none.rawValue
    )
  )

  //  @ObservationIgnored
  var storage: ColourValueStorage

  /// The array of `k` centroids.
  //  @ObservationIgnored
  var centroids = [Centroid]()

  /// The array of `k` dominant colors that the app derives from `centroids` and displays  in the user interface.
  @Published var dominantColors: [DominantColor] = []
  //  @Published var dominantColors = [DominantColor.zero]

  /// The BNNS array descriptor that receives the centroid indices.
  //  @ObservationIgnored
  let centroidIndicesDescriptor: BNNSNDArrayDescriptor

  //  @ObservationIgnored
  let maximumIterations = 50

  //  @ObservationIgnored
  var iterationCount = 0

  public init(
    dimension: Int = 256
  ) {

    print("Have started the DominantColourHandler initialiser — let's see how far we get.")
    self.dimension = dimension
    self.storage = ColourValueStorage(dimension: dimension)

    self.centroidIndicesDescriptor = BNNSNDArrayDescriptor.allocateUninitialized(
      scalarType: Int32.self,
      shape: .matrixRowMajor(dimension * dimension, 1)
    )
    print("Successfully allocated the `BNNSNDArrayDescriptor`, `centroidIndicesDescriptor` is set up")

    self.allocateDistancesBuffer()
  }

  @MainActor
  deinit {
    storage.redStorage.deallocate()
    storage.greenStorage.deallocate()
    storage.blueStorage.deallocate()

    storage.redQuantizedStorage.deallocate()
    storage.greenQuantizedStorage.deallocate()
    storage.blueQuantizedStorage.deallocate()

    centroidIndicesDescriptor.deallocate()
    distances?.deallocate()
  }

}

extension DominantColourHandler {

  func didSetCentroids() {
    allocateDistancesBuffer()
    calculateKMeans()
  }



  func setUp(_ fileURL: URL) {
    print("Ran setup method once the image is downloaded. It should exist at \(fileURL)")
    self.imageFileURL = fileURL
    generateThumbnailRepresentations()
    calculateKMeans()
  }

  /// Updates centroids and returns true if pixel counts haven't changed (that is, the solution converged).
  ///
  /// 1. Create k random centroids selected from the RGB colors in an image.
  /// 2. Create a distances matrix that has pixel-count columns and k rows.
  /// 3. For each centroid, populate the corresponding row in distances matrix with the distance-squared
  /// between it and each matrix.
  /// 4. Use BNNS reduction argMin on the distances matrix to create a vector with pixel-count elements.
  /// Each element in the vector is the centroid that's the closest color to the corresponding pixel.
  /// 5. For each centroid, use BNNS gather to create a new vector for each RGB channel of the pixel
  /// colors for that centroid. Compute the mean value of that vector and set the centroid color to that average.
  /// 6. Repeat steps 3, 4, and 5 until the solution converges.
  /// - Tag: updateCentroids
  func updateCentroids() -> Bool {
    print("Updating centroids.")
    // The pixel counts per centroid before this iteration.
    let pixelCounts = centroids.map { return $0.pixelCount }

    populateDistances()
    let centroidIndices = makeCentroidIndices()

    for centroid in centroids.enumerated() {

      // The indices into the red, green, and blue descriptors for this centroid.
      let indices = centroidIndices.enumerated().filter {
        $0.element == centroid.offset
      }.map {
        // `vDSP.gather` uses one-based indices.
        UInt($0.offset + 1)
      }

      centroids[centroid.offset].pixelCount = indices.count

      if !indices.isEmpty {
        let gatheredRed = vDSP.gather(
          storage.redStorage,
          indices: indices)

        let gatheredGreen = vDSP.gather(
          storage.greenStorage,
          indices: indices)

        let gatheredBlue = vDSP.gather(
          storage.blueStorage,
          indices: indices)

        centroids[centroid.offset].red = vDSP.mean(gatheredRed)
        centroids[centroid.offset].green = vDSP.mean(gatheredGreen)
        centroids[centroid.offset].blue = vDSP.mean(gatheredBlue)
      }
    }

    return pixelCounts.elementsEqual(centroids.map { return $0.pixelCount }) { a, b in
      return abs(a - b) < tolerance
    }
  }

  func calculateKMeans() {
    print("Running `calculateKMeans`...")
    guard let url = self.imageFileURL else {
      print("No image file path yet")
      return
    }

    guard let cgImage = ThumbnailGenerator.cgImageFromURL(url)
    //    guard let cgImage = self.thumbnailCGImageFromURL(url, maxPixelSize: 120)
    else {
      print("Unable to create a CGImage from URL")
      return
      ////      fatalError("Couldn't get cg image?")
    }
    //    guard let cgImage = NSImage(contentsOf: url)?.cgImage(
    //      forProposedRect: nil,
    //      context: nil,
    //      hints: nil
    //    )

    self.sourceImage = cgImage
    self.quantizedImage = sourceImage

    guard let unwrappedRGBFormat = rgbImageFormat else {
      print("Failed to get value for `rgbImageFormat`")
      return
    }

    var mutableRGBFormat = unwrappedRGBFormat

    guard let sourceImage,
      let rgbSources = try? vImage.PixelBuffer<vImage.InterleavedFx3>(
        cgImage: sourceImage,
        cgImageFormat: &mutableRGBFormat
      ).planarBuffers()
    else {
      fatalError("Couldn't get rgb sources?")
    }

    rgbSources[0].scale(destination: storage.redBuffer)
    rgbSources[1].scale(destination: storage.greenBuffer)
    rgbSources[2].scale(destination: storage.blueBuffer)

    self.isBusy = true

    initializeCentroids()
    updateCentroidNodes()
    update()
  }

  func allocateDistancesBuffer() {
    print("Going to allocate distances buffer")
    if distances != nil {
      distances?.deallocate()
    } else {
      print("Distances is nil")
    }
    let capacity: Int = dimension * dimension * k
    distances = UnsafeMutableBufferPointer<Float>.allocate(capacity: capacity)
    print("Distances allocated, with capacity: \(capacity)")
  }

  // MARK: - Did sets
  func didSetK() {
    print("`k` was updated, let's run the allocation and calculation methods")
    //  didSet {
    allocateDistancesBuffer()
    calculateKMeans()
    //  }

  }

  /// Iterates over the `updateCentroids` function until the solution converges or the
  /// iteration count equals `maximumIterations`.
  func update() {
    Task {
      var converged = false
      var iterationCount = 0

      while !converged && iterationCount < maximumIterations {
        converged = updateCentroids()
        iterationCount += 1
      }

      NSLog("Converged in \(iterationCount) iterations.")

      Task { @MainActor in
        //      DispatchQueue.main.async { [self] in

        dominantColors = centroids.map {
          DominantColor($0, dimension: dimension)
        }

        updateCentroidNodes()
        makeQuantizedImage()
        isBusy = false
      }
    }
  }

  /// - Tag: initializeCentroids
  func initializeCentroids() {
    self.centroids.removeAll()

    let randomIndex = Int.random(in: 0..<dimension * dimension)
    centroids.append(
      Centroid(
        red: storage.redStorage[randomIndex],
        green: storage.greenStorage[randomIndex],
        blue: storage.blueStorage[randomIndex]))

    // Use the first row of the `distances` buffer as temporary storage.
    let tmp = UnsafeMutableBufferPointer(
      start: distances?.baseAddress,
      count: dimension * dimension
    )

    for i in 1..<k {
      distanceSquared(
        x0: storage.greenStorage.baseAddress, x1: centroids[i - 1].green,
        y0: storage.blueStorage.baseAddress, y1: centroids[i - 1].blue,
        z0: storage.redStorage.baseAddress, z1: centroids[i - 1].red,
        n: storage.greenStorage.count,
        result: tmp.baseAddress)

      guard let weightedRandomIndex = weightedRandomIndex(tmp) else {
        print("Couldn't create the next centroid.")
        break
      }

      centroids.append(
        Centroid(
          red: storage.redStorage[weightedRandomIndex],
          green: storage.greenStorage[weightedRandomIndex],
          blue: storage.blueStorage[weightedRandomIndex]))
    }

    // NOTE: If centroids count changes elsewhere, ensure `centroidNodes` are synchronized accordingly.
  }

  func distanceSquared(
    x0: UnsafePointer<Float>?,
    x1: Float,
    y0: UnsafePointer<Float>?,
    y1: Float,
    z0: UnsafePointer<Float>?,
    z1: Float,
    n: Int,
    result: UnsafeMutablePointer<Float>?
  ) {
    guard let x0, let y0, let z0, let result else {
      print("No value for x0 / y0 / z0 / result in `distanceSquared`")
      return
    }
    var x = subtract(a: x0, b: x1, n: n)
    vDSP.square(x, result: &x)

    var y = subtract(a: y0, b: y1, n: n)
    vDSP.square(y, result: &y)

    var z = subtract(a: z0, b: z1, n: n)
    vDSP.square(z, result: &z)

    vDSP_vadd(x, 1, y, 1, result, 1, vDSP_Length(n))
    vDSP_vadd(result, 1, z, 1, result, 1, vDSP_Length(n))
  }

  func subtract(
    a: UnsafePointer<Float>,
    b: Float,
    n: Int
  ) -> [Float] {
    //    guard let address = buff
    //    return
    let result = [Float](unsafeUninitializedCapacity: n) {
      buffer, count in

      guard let address = buffer.baseAddress else {
        print("No base address for buffer")
        return
      }
      vDSP_vsub(a, 1, [b], 0, address, 1, vDSP_Length(n))

      count = n
    }
    return result
  }

  func saturate<T: FloatingPoint>(_ x: T) -> T {
    return min(max(0, x), 1)
  }
  //  func didSetSourceImages() {
  //    if sourceImages.count == 1 {
  //      selectedThumbnail = sourceImages.first!
  //    }
  //  }

  func weightedRandomIndex(_ weights: UnsafeMutableBufferPointer<Float>) -> Int? {
    var outputDescriptor = BNNSNDArrayDescriptor.allocateUninitialized(
      scalarType: Float.self,
      shape: .vector(1))

    guard
      let probabilities = BNNSNDArrayDescriptor(
        data: weights,
        shape: .vector(weights.count)
      )
    else {
      print("Failed to create `BNNSNDArrayDescriptor` for probabilities")
      return nil
    }

    var mutableProbabilities = probabilities

    let randomGenerator = BNNSCreateRandomGenerator(
      BNNSRandomGeneratorMethodAES_CTR,
      nil)

    BNNSRandomFillCategoricalFloat(
      randomGenerator, &outputDescriptor, &mutableProbabilities, false)

    defer {
      BNNSDestroyRandomGenerator(randomGenerator)
      outputDescriptor.deallocate()
    }

    guard let descriptors = outputDescriptor.makeArray(of: Float.self),
      let firstDesc = descriptors.first
    else {
      return nil
    }

    return Int(firstDesc)

    //    return !.first!)
  }

  func populateDistances() {

    //    guard let distances, let address = distances.baseAddress else {
    //      print("Couldn't get distances value or base address")
    //      return
    //    }
    for centroid in centroids.enumerated() {
      let result: UnsafeMutablePointer<Float>? = distances?.baseAddress?.advanced(
        by: dimension * dimension * centroid.offset
      )
      distanceSquared(
        x0: storage.greenStorage.baseAddress,
        x1: centroid.element.green,
        y0: storage.blueStorage.baseAddress,
        y1: centroid.element.blue,
        z0: storage.redStorage.baseAddress,
        z1: centroid.element.red,
        n: storage.greenStorage.count,
        result: result
      )
    }
  }

  /// Returns the index of the closest centroid for each color.
  func makeCentroidIndices() -> [Int32] {
    guard let distances else {
      print("No distances value")
      return []
    }
    guard
      let distancesDescriptor = BNNSNDArrayDescriptor(
        data: distances,
        shape: .matrixRowMajor(dimension * dimension, k)
      )
    else {
      print("Couldn't make the ditsnaces thingy")
      return []
    }

    let reductionLayer = BNNS.ReductionLayer(
      function: .argMin,
      input: distancesDescriptor,
      output: centroidIndicesDescriptor,
      weights: nil)

    try? reductionLayer?.apply(
      batchSize: 1,
      input: distancesDescriptor,
      output: centroidIndicesDescriptor)

    guard let result = centroidIndicesDescriptor.makeArray(of: Int32.self) else {
      print("Couldn't do the  centroidIndicesDescriptor thing")
      return []
    }

    return result
  }

  /// Updates the centroid SceneKit nodes.
  ///
  /// Synchronizes the `centroidNodes` array with the current `centroids` array to avoid out-of-bounds
  /// errors during updates. This includes adding or removing nodes to match the count of centroids.
  func updateCentroidNodes() {
    // Ensure centroidNodes array is in sync with centroids
    if centroidNodes.count != centroids.count {
      // Remove excess nodes
      if centroidNodes.count > centroids.count {
        centroidNodes.removeLast(centroidNodes.count - centroids.count)
      }
      // Add new nodes as needed
      while centroidNodes.count < centroids.count {
        let node = SCNNode()
        // Optionally, basic geometry for visualization
        node.geometry = SCNSphere(radius: 0.02)
        centroidNodes.append(node)
      }
    }

    // Now update each node's position and color
    for centroid in centroids.enumerated() {
      guard centroid.offset < centroidNodes.count else {
        print("[updateCentroidNodes] Error: centroidNodes index out of range for offset \(centroid.offset)")
        continue
      }
      let red = CGFloat(saturate(centroid.element.red))
      let green = CGFloat(saturate(centroid.element.green))
      let blue = CGFloat(saturate(centroid.element.blue))

      let node = centroidNodes[centroid.offset]
      node.position = .init(
        x: red,
        y: green,
        z: blue)

      node.geometry?.firstMaterial?.diffuse.contents = NSColor(
        red: red,
        green: green,
        blue: blue,
        alpha: 1.0)
    }
  }

  /// Produces a quantized image based on the dominant colors.
  func makeQuantizedImage() {
    storage.redQuantizedBuffer.overwriteChannels(withScalar: 0)
    storage.greenQuantizedBuffer.overwriteChannels(withScalar: 0)
    storage.blueQuantizedBuffer.overwriteChannels(withScalar: 0)

    populateDistances()
    let centroidIndices = makeCentroidIndices()

    for centroid in centroids.enumerated() {
      something(centroid, indices: centroidIndices)
    }

    let interleaved = vImage.PixelBuffer<vImage.InterleavedFx3>(planarBuffers: [
      storage.redQuantizedBuffer,
      storage.greenQuantizedBuffer,
      storage.blueQuantizedBuffer,
    ])

    if let rgbImageFormat, let image = interleaved.makeCGImage(cgImageFormat: rgbImageFormat) {
      quantizedImage = image
    }
  }

  private func something(
    //    _ centroid: Int32,
    _ centroid: (offset: Int, element: Centroid),
    indices centroidIndices: [Int32]
  ) {
    let indices = centroidIndices.enumerated().filter {
      $0.element == centroid.offset
    }.map {
      Int32($0.offset)
    }

    let indicesDescriptor = BNNSNDArrayDescriptor.allocate(
      initializingFrom: indices,
      shape: .vector(indices.count)
    )

    defer {
      indicesDescriptor.deallocate()
    }

    scatter(value: centroid.element.red, to: storage.redQuantizedStorage)
    scatter(value: centroid.element.green, to: storage.greenQuantizedStorage)
    scatter(value: centroid.element.blue, to: storage.blueQuantizedStorage)

    /// Scatters the repeated `value` to the `destination` using the `indicesDescriptor`.
    func scatter(
      value: Float,
      to destination: UnsafeMutableBufferPointer<Float>
    ) {
      let srcDescriptor = BNNSNDArrayDescriptor.allocate(
        repeating: value,
        shape: .vector(indices.count)
      )

      guard
        let dstDescriptor = BNNSNDArrayDescriptor(
          data: destination,
          shape: .vector(dimension * dimension)
        )
      else {
        print("Error with `dstDescriptor`, no value")
        return
      }

      do {
        try BNNS.scatter(
          input: srcDescriptor,
          indices: indicesDescriptor,
          output: dstDescriptor,
          axis: 0,
          reductionFunction: .sum)

      } catch {
        print("Error scattering: \(error)")
      }

      srcDescriptor.deallocate()
    }
  }  // END centroid something


  func generateThumbnailRepresentations() {

    guard let url = imageFileURL else {
      assert(false, "The URL can't be nil")
      return
    }

    guard let cgImage = ThumbnailGenerator.thumbnailCGImageFromURL(url, maxPixelSize: 30) else {
      print("Error with either `CGImageSourceCreateWithURL` or `CGImageSourceCreateImageAtIndex`")
      return
    }

    self.image = Thumbnail(thumbnail: cgImage)
  }
}

//extension CGImage {
//  /// A 1 x 1 Core Graphics image.
//  static var emptyCGImage: CGImage? {
//    let buffer = vImage.PixelBuffer(
//      pixelValues: [0],
//      size: .init(width: 1, height: 1),
//      pixelFormat: vImage.Planar8.self)
//
//    guard
//      let fmt = vImage_CGImageFormat(
//        bitsPerComponent: 8,
//        bitsPerPixel: 8,
//        colorSpace: CGColorSpaceCreateDeviceGray(),
//        bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue),
//        renderingIntent: .defaultIntent
//      )
//    else {
//      print("No value for the `fmt` thing")
//      return nil
//    }
//
//    return buffer.makeCGImage(cgImageFormat: fmt)
//  }
//}
