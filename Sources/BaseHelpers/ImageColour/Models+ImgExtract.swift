//
//  Models+ImgExtract.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//

import CoreGraphics
import SwiftUI
import Accelerate

struct ColourValueStorage {
  
  let dimension: Int 

  /// The storage and pixel buffer for each red value.
  let redStorage = UnsafeMutableBufferPointer<Float>.allocate(capacity: dimension * dimension)
  let redBuffer: vImage.PixelBuffer<vImage.PlanarF>
  
  /// The storage and pixel buffer for each green value.
  let greenStorage = UnsafeMutableBufferPointer<Float>.allocate(capacity: dimension * dimension)
  let greenBuffer: vImage.PixelBuffer<vImage.PlanarF>
  
  /// The storage and pixel buffer for each blue value.
  let blueStorage = UnsafeMutableBufferPointer<Float>.allocate(capacity: dimension * dimension)
  let blueBuffer: vImage.PixelBuffer<vImage.PlanarF>
  
  /// The storage and pixel buffer for each quantized red value.
  let redQuantizedStorage = UnsafeMutableBufferPointer<Float>.allocate(capacity: dimension * dimension)
  let redQuantizedBuffer: vImage.PixelBuffer<vImage.PlanarF>
  
  /// The storage and pixel buffer for each quantized green value.
  let greenQuantizedStorage = UnsafeMutableBufferPointer<Float>.allocate(capacity: dimension * dimension)
  let greenQuantizedBuffer: vImage.PixelBuffer<vImage.PlanarF>
  
  /// The storage and pixel buffer for each quantized blue value.
  let blueQuantizedStorage = UnsafeMutableBufferPointer<Float>.allocate(capacity: dimension * dimension)
  let blueQuantizedBuffer: vImage.PixelBuffer<vImage.PlanarF>
  
  public init(dimension: Int) {
    self.dimension = dimension
    
    redBuffer = vImage.PixelBuffer<vImage.PlanarF>(
      data: redStorage.baseAddress!,
      width: dimension,
      height: dimension,
      byteCountPerRow: dimension * MemoryLayout<Float>.stride)
    
    greenBuffer = vImage.PixelBuffer<vImage.PlanarF>(
      data: greenStorage.baseAddress!,
      width: dimension,
      height: dimension,
      byteCountPerRow: dimension * MemoryLayout<Float>.stride)
    
    blueBuffer = vImage.PixelBuffer<vImage.PlanarF>(
      data: blueStorage.baseAddress!,
      width: dimension,
      height: dimension,
      byteCountPerRow: dimension * MemoryLayout<Float>.stride)
    
    redQuantizedBuffer = vImage.PixelBuffer<vImage.PlanarF>(
      data: redQuantizedStorage.baseAddress!,
      width: dimension,
      height: dimension,
      byteCountPerRow: dimension * MemoryLayout<Float>.stride)
    
    greenQuantizedBuffer = vImage.PixelBuffer<vImage.PlanarF>(
      data: greenQuantizedStorage.baseAddress!,
      width: dimension,
      height: dimension,
      byteCountPerRow: dimension * MemoryLayout<Float>.stride)
    
    blueQuantizedBuffer = vImage.PixelBuffer<vImage.PlanarF>(
      data: blueQuantizedStorage.baseAddress!,
      width: dimension,
      height: dimension,
      byteCountPerRow: dimension * MemoryLayout<Float>.stride)
  }
}

/// A structure that represents a centroid.
struct Centroid {
  /// The red channel value.
  var red: Float
  
  /// The green channel value.
  var green: Float
  
  /// The blue channel value.
  var blue: Float
  
  /// The number of pixels assigned to this cluster center.
  var pixelCount: Int = 0
}

/// A structure that represents a dominant color.
struct DominantColor: Identifiable, Comparable {
  
  init(_ centroid: Centroid) {
    self.color = Color(red: Double(centroid.red), green: Double(centroid.green), blue: Double(centroid.blue))
    self.percentage = Int(Float(centroid.pixelCount) / Float(dimension * dimension) * 100)
  }
  
  init(color: Color, percentage: Int) {
    self.color = color
    self.percentage = percentage
  }
  
  static func < (lhs: DominantColor, rhs: DominantColor) -> Bool {
    return lhs.percentage < rhs.percentage
  }
  
  var id = UUID()
  
  let color: Color
  let percentage: Int
  
  static var zero: DominantColor {
    return DominantColor(color: .clear, percentage: 0)
  }
}

/// A structure that represents a thumbnail.
struct Thumbnail: Identifiable, Hashable {
  var id = UUID()
  
  let thumbnail: CGImage
  var resource: String
  var ext: String
}
