//
//  BFP+Normalise.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 11/8/2025.
//

import Foundation

extension BinaryFloatingPoint {
  
  /// Normalise converts a value in a range to `0.0` to `1.0`:
  /// `fraction = (position - min) / (max - min) ()`
  ///
  /// Denormalise converts a `0.0` to `1.0` fraction
  /// back to the original range:
  /// `value = min + fraction * (max - min)`
  
  /// Converts a value in the given range into a fraction between 0.0 and 1.0.
  /// Values below/above the range will be clamped.
  public func normalised(from range: ClosedRange<Self>) -> Self {
    precondition(
      range.lowerBound < range.upperBound,
      "Range must have a positive width."
    )
    let clampedValue = min(max(self, range.lowerBound), range.upperBound)
    return (clampedValue - range.lowerBound) / (range.upperBound - range.lowerBound)
  }
  
  /// Converts a normalized fraction (between 0.0 and 1.0)
  /// back to a value within the given range.
  /// Fractions outside 0.0-1.0 will extend beyond the range proportionally.
  public func denormalised(to range: ClosedRange<Self>) -> Self {
    precondition(
      range.lowerBound < range.upperBound,
      "Range must have a positive width."
    )
    return range.lowerBound + self * (range.upperBound - range.lowerBound)
  }
  

}
