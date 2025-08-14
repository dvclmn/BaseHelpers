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

  /// Checks that this value is neither infinite, nor Nan
  public var isValid: Bool {
    return self.isFinite && !self.isNaN
  }

  public func hueWrapped() -> Self {
    let value = self.truncatingRemainder(dividingBy: 1.0)
    return value < 0 ? value + 1.0 : value
  }

  public var toDouble: Double {
    return Double(self)
  }

  public var toFloat: Float {
    return Float(self)
  }
  
  
  
  /// Map distance to a scaled distance using atan
  public func scaledDistance(
    radius: Self,
    tension: Self,
  ) -> Self {
    let tensionVaue = Double(self / tension)
    let halfPi = Double.pi / 2
    return radius * Self(atan(tensionVaue / halfPi))
  }

  /// Maps `self` (e.g. a size) into a derived value (e.g. corner radius or padding),
  /// favouring non-linear mapping via a curve.
  ///
  /// - Parameters:
  ///   - outputRange: The target range for the derived value.
  ///   - inputRange: The expected bounds of the size input.
  ///   - curve: A non-linear adjustment function, like `.squareRoot()`, or a custom easing.
  ///   - clamped: Whether to clamp input to the input range.
  /// - Returns: A derived value smoothly mapped from size.
  public func mappedNonLinearly(
    to outputRange: ClosedRange<Self>,
    from inputRange: ClosedRange<Self> = 0...CGFloat.infinity,
    using curve: (Self) -> Self = { $0 },
    clamped: Bool = true
  ) -> Self {
    let clampedSelf = clamped ? self.clamped(to: inputRange) : self
    let inputSpan = inputRange.upperBound - inputRange.lowerBound
    let normalised = (clampedSelf - inputRange.lowerBound) / inputSpan
    let curved = curve(normalised)
    let outputSpan = outputRange.upperBound - outputRange.lowerBound
    return outputRange.lowerBound + curved * outputSpan
  }

  public func toPercentString(within range: ClosedRange<Self>) -> String {
    let normalised: Double = Double(self.normalised(from: range))
    let percent = normalised * 100
    return String(percent.displayString(.fractionLength(0)) + "%")
//    return String(percent.formatted(.percent.precision(.fractionLength(0))))
  }

  /// E.g. converting `0.8` to `0.2`
  public var inversePercentage: Self {
    /// Ensure falloff is between 0.0 and 1.0
    let bounded = min(max(self, 0.0), 1.0)
    return 1.0 - bounded
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

  public var halved: Self {
    self / 2
  }

  public var clampedToPositive: Self {
    clamped(.zero, .infinity)
  }

  public var constrainedOpacity: Self {
    return min(1.0, max(0.0, self))
  }

  public var isGreaterThanZero: Bool { self > 0 }
  public var isGreaterThanOrEqualToZero: Bool { self >= 0 }

  /// Calculates height from width using the given aspect ratio
  /// - Parameter aspectRatio: The aspect ratio (width / height)
  /// - Returns: The calculated height value
  public func height(for aspectRatio: Self) -> Self {
    return self / aspectRatio
  }

  public var degreesToRadians: Self {
    self * .pi / 180
  }

  public var radiansToDegrees: Self {
    self * 180 / .pi
  }

  /// Returns the shortest angular distance between two angles
  public static func angleDelta(_ angle1: Self, _ angle2: Self) -> Self {
    var delta = angle1 - angle2

    // Normalize to [-π, π] range
    while delta > .pi { delta -= 2 * .pi }
    while delta < -.pi { delta += 2 * .pi }

    return abs(delta)
  }

}
