//
//  ImageColourExtract.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//


import Foundation
import Accelerate
import Cocoa
import simd
import SceneKit

let dimension = 256
let channelCount = 3
let tolerance = 10

class KMeansCalculator: ObservableObject {
  
//  let sourceImageNames: [(String, String)] = [
//    ("City_9_Building_with_Skybridge", "jpeg"),
//    ("City_5_Brick_Building", "jpeg"),
//    ("Flowers_5_Hydrangea", "jpeg"),
//    ("Plants_11_Plant_with_Dew", "jpeg"),
//    ("Food_8_Carrot", "jpeg"),
//    ("Food_21_Orange", "jpeg"),
//    ("Landscape_21_Rainbow", "JPG"),
//    ("Flowers_12_Assorted", "jpeg"),
//    ("Flowers_24_Lemon_Bloom", "jpeg"),
//    ("Landscape_22_Sailboats", "JPG"),
//    ("Animals_2_Butterfly", "jpeg"),
//    ("Landscape_3_Mountains_with_Snow", "jpeg")
//  ]
//  
//  /// The SceneKit scene that displays the RGB point cloud.
//  @Published var scene = SCNScene()
//  
//  /// A Boolean value that indicates whether the app is running.
//  @Published var isBusy = true
//  
//  /// The selected thumbnail.
//  @Published var selectedThumbnail: Thumbnail! {
//    didSet {
//      calculateKMeans()
//    }
//  }
//  
//  /// An array of source images.
//  @Published var sourceImages = [Thumbnail]() {
//    didSet {
//      if sourceImages.count == 1 {
//        selectedThumbnail = sourceImages.first!
//      }
//    }
//  }
//  
//  /// The number of centroids.
//  @Published var k = 5 {
//    didSet {
//      allocateDistancesBuffer()
//      calculateKMeans()
//    }
//  }
  
  /// The current source image.
//  @Published var sourceImage = KMeansCalculator.emptyCGImage
  
//  @Published var quantizedImage = KMeansCalculator.emptyCGImage
  
  /// The Core Graphics image format.
//  var rgbImageFormat = vImage_CGImageFormat(
//    bitsPerComponent: 32,
//    bitsPerPixel: 32 * 3,
//    colorSpace: CGColorSpaceCreateDeviceRGB(),
//    bitmapInfo: CGBitmapInfo(
//      rawValue: kCGBitmapByteOrder32Host.rawValue |
//      CGBitmapInfo.floatComponents.rawValue |
//      CGImageAlphaInfo.none.rawValue))!
  
  
  var distances: UnsafeMutableBufferPointer<Float>!
  
  
  
  
  

  
  /// The SceneKit nodes that correspond to the values in the `centroids` array.
  var centroidNodes = [SCNNode]()
  
  /// The BNNS array descriptor that receives the centroid indices.
  let centroidIndicesDescriptor: BNNSNDArrayDescriptor
  
  let maximumIterations = 50
  var iterationCount = 0
  
  /// - Tag: initClass
  init() {
    
    
    centroidIndicesDescriptor = BNNSNDArrayDescriptor.allocateUninitialized(
      scalarType: Int32.self,
      shape: .matrixRowMajor(dimension * dimension, 1))
    
    allocateDistancesBuffer()
    
    for sourceImageName in sourceImageNames {
      generateThumbnailRepresentations(forResource: sourceImageName.0,
                                       withExtension: sourceImageName.1)
    }
  }
  
  deinit {
    redStorage.deallocate()
    greenStorage.deallocate()
    blueStorage.deallocate()
    
    redQuantizedStorage.deallocate()
    greenQuantizedStorage.deallocate()
    blueQuantizedStorage.deallocate()
    
    centroidIndicesDescriptor.deallocate()
    distances.deallocate()
  }
  
  /// Allocates the memory required for the distances matrix.
  func allocateDistancesBuffer() {
    if distances != nil {
      distances.deallocate()
    }
    distances = UnsafeMutableBufferPointer<Float>.allocate(capacity: dimension * dimension * k)
  }
  
  /// Calculates k-means for the selected thumbnail.
  func calculateKMeans() {
    let url = Bundle.main.url(forResource: selectedThumbnail.resource,
                              withExtension: selectedThumbnail.ext)!
    
    sourceImage = NSImage(contentsOf: url)!.cgImage(forProposedRect: nil,
                                                    context: nil,
                                                    hints: nil)!
    
    quantizedImage = sourceImage
    
    let rgbSources: [vImage.PixelBuffer<vImage.PlanarF>] = try! vImage.PixelBuffer<vImage.InterleavedFx3>(
      cgImage: sourceImage,
      cgImageFormat: &rgbImageFormat).planarBuffers()
    
    rgbSources[0].scale(destination: redBuffer)
    rgbSources[1].scale(destination: greenBuffer)
    rgbSources[2].scale(destination: blueBuffer)
    
    isBusy = true
    
    initializeCentroids()
//    populateHistogramPointCloud()
//    updateCentroidNodes()
    
    update()
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
      
      DispatchQueue.main.async { [self] in
        
        dominantColors = centroids.map {
          DominantColor($0)
        }
        
//        updateCentroidNodes()
        makeQuantizedImage()
        isBusy = false
      }
    }
  }
  
  /// - Tag: initializeCentroids
  func initializeCentroids() {
    centroids.removeAll()
    
    let randomIndex = Int.random(in: 0 ..< dimension * dimension)
    centroids.append(Centroid(red: redStorage[randomIndex],
                              green: greenStorage[randomIndex],
                              blue: blueStorage[randomIndex]))
    
    // Use the first row of the `distances` buffer as temporary storage.
    let tmp = UnsafeMutableBufferPointer(start: distances.baseAddress!,
                                         count: dimension * dimension)
    for i in 1 ..< k {
      distanceSquared(x0: greenStorage.baseAddress!, x1: centroids[i - 1].green,
                      y0: blueStorage.baseAddress!, y1: centroids[i - 1].blue,
                      z0: redStorage.baseAddress!, z1: centroids[i - 1].red,
                      n: greenStorage.count,
                      result: tmp.baseAddress!)
      
      let randomIndex = weightedRandomIndex(tmp)
      
      centroids.append(Centroid(red: redStorage[randomIndex],
                                green: greenStorage[randomIndex],
                                blue: blueStorage[randomIndex]))
    }
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
        let gatheredRed = vDSP.gather(redStorage,
                                      indices: indices)
        
        let gatheredGreen = vDSP.gather(greenStorage,
                                        indices: indices)
        
        let gatheredBlue = vDSP.gather(blueStorage,
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
  
  /// Produces a quantized image based on the dominant colors.
  func makeQuantizedImage() {
    redQuantizedBuffer.overwriteChannels(withScalar: 0)
    greenQuantizedBuffer.overwriteChannels(withScalar: 0)
    blueQuantizedBuffer.overwriteChannels(withScalar: 0)
    
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
      
      scatter(value: centroid.element.red, to: redQuantizedStorage)
      scatter(value: centroid.element.green, to: greenQuantizedStorage)
      scatter(value: centroid.element.blue, to: blueQuantizedStorage)
      
      /// Scatters the repeated `value` to the `destination` using the `indicesDescriptor`.
      func scatter(value: Float,
                   to destination: UnsafeMutableBufferPointer<Float>) {
        let srcDescriptor = BNNSNDArrayDescriptor.allocate(repeating: value,
                                                           shape: .vector(indices.count))
        let dstDescriptor = BNNSNDArrayDescriptor(data: destination,
                                                  shape: .vector(dimension * dimension))!
        
        try! BNNS.scatter(input: srcDescriptor,
                          indices: indicesDescriptor,
                          output: dstDescriptor,
                          axis: 0,
                          reductionFunction: .sum)
        
        srcDescriptor.deallocate()
      }
    }
    
    let interleaved = vImage.PixelBuffer<vImage.InterleavedFx3>(planarBuffers: [redQuantizedBuffer,
                                                                                greenQuantizedBuffer,
                                                                                blueQuantizedBuffer])
    
    quantizedImage = interleaved.makeCGImage(cgImageFormat: rgbImageFormat)!
  }
}



import Accelerate
import QuickLookThumbnailing
import Cocoa

extension KMeansCalculator {
  
  /// Populates the `distances` memory with the distance squared between each centroid and each color.
  func populateDistances() {
    for centroid in centroids.enumerated() {
      distanceSquared(x0: greenStorage.baseAddress!, x1: centroid.element.green,
                      y0: blueStorage.baseAddress!, y1: centroid.element.blue,
                      z0: redStorage.baseAddress!, z1: centroid.element.red,
                      n: greenStorage.count,
                      result: distances.baseAddress!.advanced(by: dimension * dimension * centroid.offset))
    }
  }
  
  /// Returns the index of the closest centroid for each color.
  func makeCentroidIndices() -> [Int32] {
    let distancesDescriptor = BNNSNDArrayDescriptor(
      data: distances,
      shape: .matrixRowMajor(dimension * dimension, k))!
    
    let reductionLayer = BNNS.ReductionLayer(function: .argMin,
                                             input: distancesDescriptor,
                                             output: centroidIndicesDescriptor,
                                             weights: nil)
    
    try! reductionLayer?.apply(batchSize: 1,
                               input: distancesDescriptor,
                               output: centroidIndicesDescriptor)
    
    return centroidIndicesDescriptor.makeArray(of: Int32.self)!
  }
  
  /// A 1 x 1 Core Graphics image.
  static var emptyCGImage: CGImage = {
    let buffer = vImage.PixelBuffer(
      pixelValues: [0],
      size: .init(width: 1, height: 1),
      pixelFormat: vImage.Planar8.self)
    
    let fmt = vImage_CGImageFormat(
      bitsPerComponent: 8,
      bitsPerPixel: 8 ,
      colorSpace: CGColorSpaceCreateDeviceGray(),
      bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue),
      renderingIntent: .defaultIntent)
    
    return buffer.makeCGImage(cgImageFormat: fmt!)!
  }()
  
  /// Generates a thumbnails for a specified resource.
  ///
  /// See: [Creating Quick Look Thumbnails to Preview Files in Your App](https://developer.apple.com/documentation/quicklookthumbnailing/creating_quick_look_thumbnails_to_preview_files_in_your_app)
  func generateThumbnailRepresentations(forResource resource: String,
                                        withExtension ext: String) {
    
    // Set up the parameters of the request.
    guard let url = Bundle.main.url(forResource: resource,
                                    withExtension: ext) else {
      
      // Handle the error case.
      assert(false, "The URL can't be nil")
      return
    }
    let size: CGSize = CGSize(width: 100, height: 100)
    let scale = NSScreen.main?.backingScaleFactor ?? 1
    
    // Create the thumbnail request.
    let request = QLThumbnailGenerator.Request(fileAt: url,
                                               size: size,
                                               scale: scale,
                                               representationTypes: .thumbnail)
    
    // Retrieve the singleton instance of the thumbnail generator and generate the thumbnails.
    let generator = QLThumbnailGenerator.shared
    generator.generateRepresentations(for: request) { (thumbnail, type, error) in
      DispatchQueue.main.async {
        if let thumbnail = thumbnail {
          let x = Thumbnail(thumbnail: thumbnail.cgImage,
                            resource: resource,
                            ext: ext)
          self.sourceImages.append(x)
        }
      }
    }
  }
  
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
  
  func distanceSquared(
    x0: UnsafePointer<Float>, x1: Float,
    y0: UnsafePointer<Float>, y1: Float,
    z0: UnsafePointer<Float>, z1: Float,
    n: Int,
    result: UnsafeMutablePointer<Float>) {
      
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
      
      vDSP_vsub(a, 1,
                [b], 0,
                buffer.baseAddress!, 1,
                vDSP_Length(n))
      
      count = n
    }
  }
  
  func saturate<T: FloatingPoint>(_ x: T) -> T {
    return min(max(0, x), 1)
  }
}
