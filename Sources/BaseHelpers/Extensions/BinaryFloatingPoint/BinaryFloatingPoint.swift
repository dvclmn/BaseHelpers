//
//  BinaryFloatingPoint.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 27/2/2025.
//

import Foundation

public var twoPi: CGFloat { .pi * 2 }

/// Looking for `clamp` methods? See `Extrensions/Comparable`
extension BinaryFloatingPoint {

  public func incrementing(by amount: Self, in range: ClosedRange<Self>? = nil) -> Self {
    var result = self + amount
    if let range {
      result = min(max(result, range.lowerBound), range.upperBound)
    }
    return result
  }

  public mutating func increment(by amount: Self, in range: ClosedRange<Self>? = nil) {
    self = incrementing(by: amount, in: range)
  }

  public func hueWrapped() -> Self {
    let value = self.truncatingRemainder(dividingBy: 1.0)
    return value < 0 ? value + 1.0 : value
  }

  public var toUnitInterval: UnitInterval { return UnitInterval(Double(self)) }

  public var toUnitIntervalCyclic: UnitIntervalCyclic { return UnitIntervalCyclic(Double(self)) }

  /// Map distance to a scaled distance using atan
  public func scaledDistance(
    radius: Self,
    tension: Self,
  ) -> Self {
    let tensionVaue = Double(self / tension)
    let halfPi = Double.pi / 2
    return radius * Self(atan(tensionVaue / halfPi))
  }

  /// E.g. converting `0.8` to `0.2`
  public var inversePercentage: Self {
    /// Ensure falloff is between 0.0 and 1.0
    let bounded = min(max(self, 0.0), 1.0)
    return 1.0 - bounded
  }

  public func wrapPhase(_ phase: CGFloat) -> CGFloat {
    var r = phase.truncatingRemainder(dividingBy: twoPi)
    if r < 0 { r += twoPi }  // keep in [0, 2π)
    return r
  }

  public var bump: Self {
    let nextFib = self * 1.618
    /// Approximate next Fibonacci number
    return (self + nextFib) / 2/// Midpoint between current and next
  }

  public var bumpDown: Self {
    let prevFib = self * 0.618
    /// Approximate previous Fibonacci number using the inverse of the golden ratio
    return (self + prevFib) / 2/// Midpoint between current and previous
  }

  public var halved: Self { self / 2 }

  public var clampedToPositive: Self {
    clamped(.zero, .infinity)
  }

  public var clampedZeroToOne: Self {
    return self.clamped(0, 1)
    //    return min(1.0, max(0.0, self))
  }

  /// Calculates height from width using the given aspect ratio
  /// - Parameter aspectRatio: The aspect ratio (width / height)
  /// - Returns: The calculated height value
  public func height(for aspectRatio: Self) -> Self {
    return self / aspectRatio
  }

  /// Returns the shortest angular distance between two angles
  public static func angleDelta(_ angle1: Self, _ angle2: Self) -> Self {
    var delta = angle1 - angle2

    // Normalize to [-π, π] range
    while delta > .pi { delta -= 2 * .pi }
    while delta < -.pi { delta += 2 * .pi }

    return abs(delta)
  }

  public static func randomNoise(
    _ phaseAtPosition: CGFloat = 0
  ) -> CGFloat {
    sin(phaseAtPosition * 7.3) * 0.3 + cos(phaseAtPosition * 13.7) * 0.2
  }


}
