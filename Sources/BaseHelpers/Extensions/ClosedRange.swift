//
//  ClosedRange.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 11/7/2025.
//

import Foundation

extension ClosedRange where Bound == CGFloat {
  public var toDoubleRange: ClosedRange<Double> {
    Double(self.lowerBound) ... Double(self.upperBound)
  }
}
extension ClosedRange where Bound == Double {
  
 
  public var toCGFloatRange: ClosedRange<CGFloat> {
    CGFloat(self.lowerBound) ... CGFloat(self.upperBound)
  }
}

extension ClosedRange where Bound: BinaryFloatingPoint {
  /// "Give me the value that is 20% along the zoom range"
  /// `let zoom = (0.1...40).value(atPercent: 0.2)  // → 8.08`
  /// The inverse operation of the below `fractionThroughRange(for:)`
  public func value(atPercent percent: Self.Bound) -> Self.Bound {
    lowerBound + (upperBound - lowerBound) * percent
  }
  
  /// Returns the fractional position of the given value within the range.
  /// The inverse operation of the above `value(atPercent:)`
  /// "How far through the zoom range is 8.08?"
  /// `let percent = (0.1...40).fractionThroughRange(for: 8.08)  // → 0.2`
  ///
  /// This calculates how far `value` lies between the range’s lower and upper bounds,
  /// as a `Double` between `0.0` (at the lower bound) and `1.0` (at the upper bound).
  ///
  /// For example, if the range is `10.0...20.0` and the value is `15.0`, the result is `0.5`.
  /// This is useful for mapping values to percentage-based logic.
  ///
  /// - Parameter value: A value that lies somewhere within or near this range.
  /// - Returns: A `Double` representing how far through the range the value lies.
  public func fractionThroughRange(for value: Self.Bound) -> Self.Bound {
    guard lowerBound != upperBound else { return 0.0 }
    return (value - lowerBound) / (upperBound - lowerBound)
  }
}
