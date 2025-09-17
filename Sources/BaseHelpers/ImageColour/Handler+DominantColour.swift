//
//  Handler+DominantColour.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//

import Accelerate
import SwiftUI

public class DominantColourHandler {
  var isBusy: Bool = false
  let image: Image

  public init(
    image: Image
  ) {
    self.image = image
  }

  var distances: UnsafeMutableBufferPointer<Float>!

  /// The number of centroids.
  var k = 5

  var sourceImage = CGImage.emptyCGImage
  var quantizedImage = CGImage.emptyCGImage

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
  
  
  /// The BNNS array descriptor that receives the centroid indices.
  let centroidIndicesDescriptor: BNNSNDArrayDescriptor
  
  let maximumIterations = 50
  var iterationCount = 0

}

extension DominantColourHandler {
  func allocateDistancesBuffer() {
    if distances != nil {
      distances.deallocate()
    }
    distances = UnsafeMutableBufferPointer<Float>.allocate(capacity: dimension * dimension * k)
  }

  func didSetK() {
    //  didSet {
    allocateDistancesBuffer()
    calculateKMeans()
    //  }

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
