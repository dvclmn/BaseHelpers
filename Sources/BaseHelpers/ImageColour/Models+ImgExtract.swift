//
//  Models+ImgExtract.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//

@preconcurrency import Accelerate
import CoreGraphics
import SwiftUI

//@MainActor
final class ColourValueStorage {

  let dimension: Int

  /// The storage and pixel buffer for each colour value
  let redStorage: UnsafeMutableBufferPointer<Float>
  let greenStorage: UnsafeMutableBufferPointer<Float>
  let blueStorage: UnsafeMutableBufferPointer<Float>

  let redBuffer: vImage.PixelBuffer<vImage.PlanarF>
  let greenBuffer: vImage.PixelBuffer<vImage.PlanarF>
  let blueBuffer: vImage.PixelBuffer<vImage.PlanarF>

  /// The storage and pixel buffer for each *quantized* colour value.
  let redQuantizedStorage: UnsafeMutableBufferPointer<Float>
  let greenQuantizedStorage: UnsafeMutableBufferPointer<Float>
  let blueQuantizedStorage: UnsafeMutableBufferPointer<Float>

  let redQuantizedBuffer: vImage.PixelBuffer<vImage.PlanarF>
  let greenQuantizedBuffer: vImage.PixelBuffer<vImage.PlanarF>
  let blueQuantizedBuffer: vImage.PixelBuffer<vImage.PlanarF>

  // MARK: - Initialiser
  public init(dimension: Int) {
    print("Starting up `ColourValueStorage` with dimension: \(dimension)")
    
    self.dimension = dimension

    // allocate all buffers now that dimension is known
    self.redStorage = .allocate(capacity: dimension * dimension)
    self.greenStorage = .allocate(capacity: dimension * dimension)
    self.blueStorage = .allocate(capacity: dimension * dimension)

    self.redQuantizedStorage = .allocate(capacity: dimension * dimension)
    self.greenQuantizedStorage = .allocate(capacity: dimension * dimension)
    self.blueQuantizedStorage = .allocate(capacity: dimension * dimension)

    self.redBuffer = vImage.PixelBuffer<vImage.PlanarF>(
      data: redStorage.baseAddress!,
      width: dimension,
      height: dimension,
      byteCountPerRow: dimension * MemoryLayout<Float>.stride)

    self.greenBuffer = vImage.PixelBuffer<vImage.PlanarF>(
      data: greenStorage.baseAddress!,
      width: dimension,
      height: dimension,
      byteCountPerRow: dimension * MemoryLayout<Float>.stride)

    self.blueBuffer = vImage.PixelBuffer<vImage.PlanarF>(
      data: blueStorage.baseAddress!,
      width: dimension,
      height: dimension,
      byteCountPerRow: dimension * MemoryLayout<Float>.stride)

    self.redQuantizedBuffer = vImage.PixelBuffer<vImage.PlanarF>(
      data: redQuantizedStorage.baseAddress!,
      width: dimension,
      height: dimension,
      byteCountPerRow: dimension * MemoryLayout<Float>.stride)

    self.greenQuantizedBuffer = vImage.PixelBuffer<vImage.PlanarF>(
      data: greenQuantizedStorage.baseAddress!,
      width: dimension,
      height: dimension,
      byteCountPerRow: dimension * MemoryLayout<Float>.stride)

    self.blueQuantizedBuffer = vImage.PixelBuffer<vImage.PlanarF>(
      data: blueQuantizedStorage.baseAddress!,
      width: dimension,
      height: dimension,
      byteCountPerRow: dimension * MemoryLayout<Float>.stride)
    
    print("`ColourValueStorage` is now up and running")
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

  init(_ centroid: Centroid, dimension: Int) {
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
struct Thumbnail: Identifiable, Hashable, Sendable {
  var id = UUID()
  let thumbnail: CGImage
//  let fileURL: URL
  //  var name: String
  //  var resource: String
  //  var ext: String
}
