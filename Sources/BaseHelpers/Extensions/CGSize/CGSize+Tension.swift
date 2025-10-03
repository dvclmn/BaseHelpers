//
//  CGSize+Tension.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 21/8/2025.
//

import Foundation

public enum DragTensionArea {
  case shortestDimension(CGFloat)
  case widthAndHeight(CGSize)
}

extension CGSize {

  /// Applies a non-linear "elastic" tension, where `self` is a raw drag offset
  /// - Parameters:
  ///   - area: Defines the tension boundary - either uniform based on shortest dimension or independent for width/height
  ///   - tension: Controls the softness of the pull. Larger = softer.
  /// - Returns: A new offset, scaled to feel like it's tethered by an elastic band.
  public func applyTension(
    area: DragTensionArea,
    tension: CGFloat
  ) -> CGSize {
    switch area {
      case .shortestDimension(let radius):
        return applyUniformTension(radius: radius, tension: tension)
      case .widthAndHeight(let radii):
        return applyIndependentTension(radii: radii, tension: tension)
    }
  }

  /// Applies uniform tension based on overall distance from origin
  private func applyUniformTension(
    radius: CGFloat,
    tension: CGFloat
  ) -> CGSize {
    let distance = self.length
    guard distance > 0 else { return .zero }
    let scaled = distance.scaledDistance(
      radius: radius,
      tension: tension
    )
    return self.normalisedLength * scaled
  }

  /// Applies independent tension to X and Y components
  private func applyIndependentTension(
    radii: CGSize,
    tension: CGFloat
  ) -> CGSize {
    guard self != .zero else { return .zero }

    func scaledAxis(_ value: CGFloat, radius: CGFloat) -> CGFloat {
      guard value != 0 else { return 0 }
      let absVal = abs(value)
      let scaled = absVal.scaledDistance(
        radius: radius,
        tension: tension
      )
      return value.sign == .minus ? -scaled : scaled
    }

    return CGSize(
      width: scaledAxis(width, radius: radii.width),
      height: scaledAxis(height, radius: radii.height)
    )
  }

}
