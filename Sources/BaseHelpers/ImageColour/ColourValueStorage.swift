//
//  ColourValueStorage.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//

@preconcurrency import Accelerate
import CoreGraphics
import SwiftUI

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
