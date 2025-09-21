//
//  BFP+Checks.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 21/9/2025.
//

import Foundation

extension BinaryFloatingPoint {
  
  /// Checks that this value is neither infinite, nor Nan
  public var isValid: Bool {
    return self.isFinite && !self.isNaN
  }
  
  /// Returns `true` if this value falls within the specified closed range (inclusive of bounds).
  /// - Parameter range: The closed range to check against
  /// - Returns: `true` if the value is within the range, `false` otherwise
  public func isWithin(_ range: ClosedRange<Self>) -> Bool {
    return range.contains(self)
  }
  
  /// Returns `true` if this value falls within the specified bounds (inclusive).
  /// - Parameters:
  ///   - lowerBound: The lower bound (inclusive)
  ///   - upperBound: The upper bound (inclusive)
  /// - Returns: `true` if the value is within the bounds, `false` otherwise
  public func isWithin(_ lowerBound: Self, _ upperBound: Self) -> Bool {
    return self >= lowerBound && self <= upperBound
  }
  
  public var isGreaterThanZero: Bool { self > 0 }
  public var isGreaterThanOrEqualToZero: Bool { self >= 0 }

}
