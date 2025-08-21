//
//  CGSize+Tension.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 21/8/2025.
//

import Foundation

extension CGSize {
  
  
  /// Applies a non-linear "elastic" tension, where `self` is a raw drag offset
  /// - Parameters:
  ///   - radius: The maximum effective drag distance (beyond this, movement flattens out).
  ///   - tension: Controls the softness of the pull. Larger = softer.
  /// - Returns: A new offset, scaled to feel like it's tethered by an elastic band.
  public func applyTension(
    radius: CGFloat,
    tension: CGFloat,
  ) -> CGSize {
    let distance = self.length
    guard distance > 0 else { return .zero }
    
    let scaled = distance.scaledDistance(
      radius: radius,
      tension: tension,
    )
    return self.normalisedLength * scaled
  }
  
  /// Applies a non-linear "elastic" tension, with independent X and Y radii.
  /// - Parameters:
  ///   - radii: Maximum effective drag distances for X and Y before flattening.
  ///   - tension: Controls the softness of the pull. Larger = softer.
  public func applyTension(
    radii: CGSize,
    tension: CGFloat,
  ) -> CGSize {
    guard self != .zero else { return .zero }
    
    func scaledAxis(_ value: CGFloat, radius: CGFloat) -> CGFloat {
      guard value != 0 else { return 0 }
      let absVal = abs(value)
      
      let scaled = absVal.scaledDistance(
        radius: radius,
        tension: tension,
      )
      return value.sign == .minus ? -scaled : scaled
    }
    
    return CGSize(
      width: scaledAxis(width, radius: radii.width),
      height: scaledAxis(height, radius: radii.height)
    )
  }

}
