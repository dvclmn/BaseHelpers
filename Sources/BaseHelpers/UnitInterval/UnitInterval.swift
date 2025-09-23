//
//  UnitInterval.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/9/2025.
//

import Foundation
import CurveFunctions

/// This represents a closed unit interval `[0,1]`
/// Useful for percentages, opacity, normalised values.
/// - `0` = minimum value (black, no opacity, zero progress)
/// - `1` = maximum value (white, fully opaque, complete progress)
/// - Points in between are valid and finite.
public struct UnitInterval: ExpressibleByFloatLiteral, Sendable, Equatable, Hashable, Codable {
  public typealias FloatLiteralType = Double

  public private(set) var value: Double

  public init(floatLiteral value: Double) {
    precondition(value.isFinite, "UnitInterval must be finite")
    self.value = min(max(value, 0), 1)
  }

  public init(_ value: Double) {
    self.init(floatLiteral: value)
  }
}

extension UnitInterval: Zeroable {
  public static var zero: UnitInterval { 0.0 }

  /// Standard linear interpolation
  public func interpolated(towards other: UnitInterval, strength: Double) -> UnitInterval {
    let result = lerp(from: self.value, to: other.value, strength)
    return UnitInterval(result)
  }
}

public func + (lhs: UnitInterval, rhs: Double) -> UnitInterval {
  return UnitInterval(lhs.value + rhs)
}
public func + (lhs: UnitInterval, rhs: UnitInterval) -> UnitInterval {
  return UnitInterval(lhs.value + rhs.value)
}
public func + (lhs: Double, rhs: UnitInterval) -> Double {
  return Double(lhs + rhs.value)
}
