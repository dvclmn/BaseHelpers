//
//  Handler+DominantColour.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//

import Accelerate
import SwiftUI

@Observable
public final class DominantColourHandler {
  var isBusy: Bool = false
  let image: Image

  /// Storage for a matrix with `dimension * dimension` columns and `k` rows that stores the
  /// distances squared of each pixel color for each centroid.
  @ObservationIgnored
  var distances: UnsafeMutableBufferPointer<Float>!

  /// The number of centroids.
  var k = 5

  /// An array of source images.
  var sourceImages: [Thumbnail] = []
  
  
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
    image: Image,
    dimension: Int = 256
  ) {
    self.image = image
    self.storage = ColourValueStorage(dimension: dimension)
    self.centroidIndicesDescriptor = BNNSNDArrayDescriptor.allocateUninitialized(
      scalarType: Int32.self,
      shape: .matrixRowMajor(dimension * dimension, 1)
    )
    allocateDistancesBuffer()

    for sourceImageName in sourceImageNames {
      generateThumbnailRepresentations(
        forResource: sourceImageName.0,
        withExtension: sourceImageName.1)
    }
  }

}

extension DominantColourHandler {
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

  func didSetSourceImages() {
    if sourceImages.count == 1 {
      selectedThumbnail = sourceImages.first!
    }

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
