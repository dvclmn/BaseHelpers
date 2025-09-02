//
//  UnitIntervalCyclic.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/9/2025.
//

import Foundation

/// Represents a half-open interval unit, `[0, 1)`.
/// Includes `0` but excludes `1`.
/// Useful in cyclic domains like Hue where `1` wraps to `0`.
public struct UnitIntervalCyclic: ExpressibleByFloatLiteral, Sendable, Equatable, Codable {
  private(set) var value: Double

  public init(floatLiteral value: Double) {
    precondition(value.isFinite, "UnitIntervalCyclic must be finite")
    self.value = value.truncatingRemainder(dividingBy: 1)
    if self.value < 0 { self.value += 1 }
  }

  public init(_ value: Double) {
    self.init(floatLiteral: value)
  }

  //  public init(_ value: Double) {
  //    precondition(value.isFinite, "UnitIntervalCyclic must be finite")
  //    self.value = value.truncatingRemainder(dividingBy: 1)
  //    if self.value < 0 { self.value += 1 }
  //  }
}

extension UnitIntervalCyclic {

  /// Interpolate shortest path around colour wheel
  public func interpolated(towards other: Self, strength: Double) -> Self {
    let delta = ((other.value - value + 1.5).truncatingRemainder(dividingBy: 1.0)) - 0.5
    return Self(value + delta * strength)
  }

  /// Useful for Hue
  public var degrees: Double { value * 360 }
  public init(degrees: Double) { self.init(degrees / 360) }
}

extension Optional where Wrapped == UnitIntervalCyclic {

  /// Cyclic interpolation for hue values (shortest path around color wheel)
  public func interpolated(towards other: UnitIntervalCyclic?, strength: Double) -> UnitIntervalCyclic? {
    switch (self, other) {
      case (nil, nil): return nil
      case (let hue?, nil): return hue // Keep current hue when target is nil
      case (nil, let target?): return target // Jump to target when current is nil
      case (let from?, let to?): return from.interpolated(towards: to, strength: strength)
    }
  }
  
//  /// Cyclic interpolation for hue values (shortest path around color wheel)
//  public func interpolated(towards other: UnitIntervalCyclic?, strength: Double) -> UnitIntervalCyclic? {
//    switch (self, other) {
//      case (nil, nil): return nil
//      case (let hue?, nil): return hue  // Keep current hue when target is nil
//      case (nil, let target?): return target  // Jump to target when current is nil
//      case (let from?, let to?): return from.interpolated(towards: to, strength: strength)
//    }
//  }
}

public func + (lhs: UnitIntervalCyclic, rhs: Double) -> UnitIntervalCyclic {
  return UnitIntervalCyclic(lhs.value + rhs)
}
public func + (lhs: UnitIntervalCyclic, rhs: UnitIntervalCyclic) -> UnitIntervalCyclic {
  return UnitIntervalCyclic(lhs.value + rhs.value)
}
public func + (lhs: Double, rhs: UnitIntervalCyclic) -> Double {
  return Double(lhs + rhs.value)
}
