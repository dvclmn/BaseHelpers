//
//  Handler+DominantColour.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//

import Accelerate
import Cocoa
import SceneKit
import SwiftUI
import simd

@MainActor
@Observable
public final class DominantColourHandler {
  var isBusy: Bool = false

  let image: Thumbnail?
  let dimension: Int
  let tolerance = 10
  //  let imageURL: URL
  //  let image: Image

  /// Storage for a matrix with `dimension * dimension` columns and `k` rows that stores the
  /// distances squared of each pixel color for each centroid.
  @ObservationIgnored
  var distances: UnsafeMutableBufferPointer<Float>!

  /// The number of centroids.
  var k = 5

  /// The SceneKit nodes that correspond to the values in the `centroids` array.
  var centroidNodes = [SCNNode]()
  /// The SceneKit scene that displays the RGB point cloud.
  var scene = SCNScene()

  /// An array of source images.
  //  var sourceImages: [Thumbnail] = []

  var sourceImage = CGImage.emptyCGImage
  var quantizedImage = CGImage.emptyCGImage

  @ObservationIgnored
  var rgbImageFormat = vImage_CGImageFormat(
    bitsPerComponent: 32,
    bitsPerPixel: 32 * 3,
    colorSpace: CGColorSpaceCreateDeviceRGB(),
    bitmapInfo: CGBitmapInfo(
      rawValue: kCGBitmapByteOrder32Host.rawValue
        | CGBitmapInfo.floatComponents.rawValue
        | CGImageAlphaInfo.none.rawValue
    )
  )!

  @ObservationIgnored
  var storage: ColourValueStorage

  /// The array of `k` centroids.
  @ObservationIgnored
  var centroids = [Centroid]()

  /// The array of `k` dominant colors that the app derives from `centroids` and displays  in the user interface.
  var dominantColors = [DominantColor.zero]

  /// The BNNS array descriptor that receives the centroid indices.
  @ObservationIgnored
  let centroidIndicesDescriptor: BNNSNDArrayDescriptor

  @ObservationIgnored
  let maximumIterations = 50

  @ObservationIgnored
  var iterationCount = 0

  public init(
    imageURL: URL,
    //    image: Image,
    dimension: Int = 256
  ) {
    self.dimension = dimension
    self.storage = ColourValueStorage(dimension: dimension)
    self.centroidIndicesDescriptor = BNNSNDArrayDescriptor.allocateUninitialized(
      scalarType: Int32.self,
      shape: .matrixRowMajor(dimension * dimension, 1)
    )

    var imageResult: Thumbnail?
    Task { @MainActor in
      if let imageThumbnail = await ThumbnailGenerator.generateThumbnailRepresentation(imageURL: imageURL) {
        imageResult = imageThumbnail
      }
    }  // REND task
    self.image = imageResult
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
    distances.deallocate()
  }

}

extension DominantColourHandler {

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
    //    let url = Bundle.main.url(forResource: selectedThumbnail.resource,
    //                              withExtension: selectedThumbnail.ext)!

    guard let url = self.image?.fileURL,
      let cgImage = NSImage(contentsOf: url)?.cgImage(
        forProposedRect: nil,
        context: nil,
        hints: nil
      )
    else {
      fatalError("Couldn't get cg image?")
    }

    self.sourceImage = cgImage
    self.quantizedImage = sourceImage

    guard
      let rgbSources: [vImage.PixelBuffer<vImage.PlanarF>] = try? vImage.PixelBuffer<vImage.InterleavedFx3>(
        cgImage: sourceImage,
        cgImageFormat: &rgbImageFormat
      ).planarBuffers()
    else {
      fatalError("Couldn't get rgb sources?")
    }

    rgbSources[0].scale(destination: storage.redBuffer)
    rgbSources[1].scale(destination: storage.greenBuffer)
    rgbSources[2].scale(destination: storage.blueBuffer)

    self.isBusy = true

    initializeCentroids()
    //    populateHistogramPointCloud()
    //    updateCentroidNodes()

    update()
  }

  func allocateDistancesBuffer() {
    if distances != nil {
      distances.deallocate()
    }
    distances = UnsafeMutableBufferPointer<Float>.allocate(capacity: dimension * dimension * k)
  }

  // MARK: - Did sets
  func didSetK() {
    //  didSet {
    allocateDistancesBuffer()
    calculateKMeans()
    //  }

  }

  /// Iterates over the `updateCentroids` function until the solution converges or the
  /// iteration count equals `maximumIterations`.
  func update() {
    //    Task {
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
      start: distances.baseAddress!,
      count: dimension * dimension
    )
    for i in 1..<k {
      distanceSquared(
        x0: storage.greenStorage.baseAddress!, x1: centroids[i - 1].green,
        y0: storage.blueStorage.baseAddress!, y1: centroids[i - 1].blue,
        z0: storage.redStorage.baseAddress!, z1: centroids[i - 1].red,
        n: storage.greenStorage.count,
        result: tmp.baseAddress!)

      let randomIndex = weightedRandomIndex(tmp)

      centroids.append(
        Centroid(
          red: storage.redStorage[randomIndex],
          green: storage.greenStorage[randomIndex],
          blue: storage.blueStorage[randomIndex]))
    }
  }

  func distanceSquared(
    x0: UnsafePointer<Float>, x1: Float,
    y0: UnsafePointer<Float>, y1: Float,
    z0: UnsafePointer<Float>, z1: Float,
    n: Int,
    result: UnsafeMutablePointer<Float>
  ) {

    var x = subtract(a: x0, b: x1, n: n)
    vDSP.square(x, result: &x)

    var y = subtract(a: y0, b: y1, n: n)
    vDSP.square(y, result: &y)

    var z = subtract(a: z0, b: z1, n: n)
    vDSP.square(z, result: &z)

    vDSP_vadd(x, 1, y, 1, result, 1, vDSP_Length(n))
    vDSP_vadd(result, 1, z, 1, result, 1, vDSP_Length(n))
  }

  func subtract(a: UnsafePointer<Float>, b: Float, n: Int) -> [Float] {
    return [Float](unsafeUninitializedCapacity: n) {
      buffer, count in

      vDSP_vsub(
        a, 1,
        [b], 0,
        buffer.baseAddress!, 1,
        vDSP_Length(n))

      count = n
    }
  }

  func saturate<T: FloatingPoint>(_ x: T) -> T {
    return min(max(0, x), 1)
  }
  //  func didSetSourceImages() {
  //    if sourceImages.count == 1 {
  //      selectedThumbnail = sourceImages.first!
  //    }
  //  }

  func weightedRandomIndex(_ weights: UnsafeMutableBufferPointer<Float>) -> Int {
    var outputDescriptor = BNNSNDArrayDescriptor.allocateUninitialized(
      scalarType: Float.self,
      shape: .vector(1))

    var probabilities = BNNSNDArrayDescriptor(
      data: weights,
      shape: .vector(weights.count))!

    let randomGenerator = BNNSCreateRandomGenerator(
      BNNSRandomGeneratorMethodAES_CTR,
      nil)

    BNNSRandomFillCategoricalFloat(
      randomGenerator, &outputDescriptor, &probabilities, false)

    defer {
      BNNSDestroyRandomGenerator(randomGenerator)
      outputDescriptor.deallocate()
    }

    return Int(outputDescriptor.makeArray(of: Float.self)!.first!)
  }

  func populateDistances() {
    for centroid in centroids.enumerated() {
      distanceSquared(
        x0: storage.greenStorage.baseAddress!,
        x1: centroid.element.green,
        y0: storage.blueStorage.baseAddress!,
        y1: centroid.element.blue,
        z0: storage.redStorage.baseAddress!,
        z1: centroid.element.red,
        n: storage.greenStorage.count,
        result: distances.baseAddress!.advanced(
          by: dimension * dimension * centroid.offset
        )
      )
    }
  }

  /// Returns the index of the closest centroid for each color.
  func makeCentroidIndices() -> [Int32] {
    let distancesDescriptor = BNNSNDArrayDescriptor(
      data: distances,
      shape: .matrixRowMajor(dimension * dimension, k))!

    let reductionLayer = BNNS.ReductionLayer(
      function: .argMin,
      input: distancesDescriptor,
      output: centroidIndicesDescriptor,
      weights: nil)

    try! reductionLayer?.apply(
      batchSize: 1,
      input: distancesDescriptor,
      output: centroidIndicesDescriptor)

    return centroidIndicesDescriptor.makeArray(of: Int32.self)!
  }

  /// Updates the centroid SceneKit nodes.
  func updateCentroidNodes() {
    for centroid in centroids.enumerated() {

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
      let indices = centroidIndices.enumerated().filter {
        $0.element == centroid.offset
      }.map {
        Int32($0.offset)
      }

      let indicesDescriptor = BNNSNDArrayDescriptor.allocate(
        initializingFrom: indices,
        shape: .vector(indices.count))

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
          shape: .vector(indices.count))
        let dstDescriptor = BNNSNDArrayDescriptor(
          data: destination,
          shape: .vector(dimension * dimension))!

        try! BNNS.scatter(
          input: srcDescriptor,
          indices: indicesDescriptor,
          output: dstDescriptor,
          axis: 0,
          reductionFunction: .sum)

        srcDescriptor.deallocate()
      }
    }

    let interleaved = vImage.PixelBuffer<vImage.InterleavedFx3>(planarBuffers: [
      storage.redQuantizedBuffer,
      storage.greenQuantizedBuffer,
      storage.blueQuantizedBuffer,
    ])

    quantizedImage = interleaved.makeCGImage(cgImageFormat: rgbImageFormat)!
  }
}

extension CGImage {
  /// A 1 x 1 Core Graphics image.
  static var emptyCGImage: CGImage {
    let buffer = vImage.PixelBuffer(
      pixelValues: [0],
      size: .init(width: 1, height: 1),
      pixelFormat: vImage.Planar8.self)

    let fmt = vImage_CGImageFormat(
      bitsPerComponent: 8,
      bitsPerPixel: 8,
      colorSpace: CGColorSpaceCreateDeviceGray(),
      bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue),
      renderingIntent: .defaultIntent)

    return buffer.makeCGImage(cgImageFormat: fmt!)!
  }
}
