//
//  BinaryFloatingPoint.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 27/2/2025.
//

import Foundation

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

  //  public func incrementing(by amount: Self, in range: ClosedRange<Self>) -> Self {
  //    var value = self
  //    value += amount
  //    return value.clamped(to: range)
  //  }
  //
  //  public mutating func increment(by: )

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

  public func clamped(to range: ClosedRange<Self>) -> Self {
    return min(max(self, range.lowerBound), range.upperBound)
  }

  public func clamped(toIntRange range: Range<Int>) -> Self {
    return clamped(Self(range.lowerBound), Self(range.upperBound))
  }

  //  public func displayString(
  //    _ decimalPlaces: Int = 2,
  //    grouping: FloatingPointFormatStyle<Self>.Configuration.Grouping = .automatic
  //  ) -> String {
  //    let doubleValue = Double(self)
  //    let formatted = doubleValue.formatted(.number.precision(.fractionLength(decimalPlaces)).grouping(grouping))
  //    return String(formatted)
  //  }
  //
  //  public var displayString: String {
  //    return self.displayString()
  //  }

  //  public var toInt: String {
  //    self.displayString(0)
  //    floatToString(value: self, places: 0)
  //  }

  public init(
    _ value: Self,
    removingZoom zoom: Self,
    with sensitivity: Self = 0.5
  ) {
    let clampedSensitivity = Double(sensitivity.clamped(to: 0...1))
    let adjusted = value * Self(pow(Double(zoom), clampedSensitivity - 1))
    self.init(adjusted)
  }

  /// This directly removes a zoom level, which depending on the
  /// permitted range, could be any value.
  //  public func removingZoom(_ zoom: Self) -> Self {
  //    return self / zoom
  //  }

  public func removingZoom(
    _ zoom: Self,
    clampedTo range: ClosedRange<Self>? = nil
  ) -> Self {
    guard let range else {
      return self / zoom
    }
    let clampedZoom = zoom.clamped(to: range)
    return self / clampedZoom
  }

  /// This removes a zoom range which has been normalised from 0-1
  func removingZoomPercent(_ zoomPercent: Self) -> Self {
    let result = Double(self) / pow(1 + Double(zoomPercent), 1)
    return Self(result)
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

  /// Adjusts a value to respond partially to zoom level.
  /// - Parameters:
  ///   - zoom: The current zoom factor (1.0 is default, >1.0 is zoomed in).
  ///   - responsiveness: 0 = fixed size, 1 = fully zoom-scaled, 0.5 = halfway.
  ///   - clampedTo: Optional range to constrain the final adjusted value.
  //  public func adjustedForZoom(
  //    _ zoom: Self,
  //    sensitivity: Self = 0.5,
  //  ) -> Self {
  //    let clampedSensitivity = Double(sensitivity.clamped(to: 0...1))
  //    let adjusted = self * Self(pow(Double(zoom), clampedSensitivity - 1))
  //    return adjusted
  //  }

  //  public static func adjustedForZoom(
  //    value: Self,
  //    zoom: Self,
  //    sensitivity: Self = 0.5,
  //    //    range: ClosedRange<Self>? = nil
  //  ) -> Self {
  //    let clampedSensitivity = Double(sensitivity.clamped(to: 0...1))
  //    let adjusted = value * Self(pow(Double(zoom), clampedSensitivity - 1))
  //    //    if let range = range {
  //    //      return adjusted.clamped(to: range)
  //    //    } else {
  //    //      return adjusted
  //    //    }
  //    return adjusted
  //  }

  /// Clamps the value to the given range.
  //  func clamped(to range: ClosedRange<Self>) -> Self {
  //    return min(max(self, range.lowerBound), range.upperBound)
  //  }

  //  /// Adjusts a value to respond partially to zoom level.
  //  /// - Parameters:
  //  ///   - zoom: The current zoom factor (1.0 is default, >1.0 is zoomed in).
  //  ///   - responsiveness: 0 = fixed size, 1 = fully zoom-scaled, 0.5 = halfway.
  //  public func adjustedForZoom(
  //    _ zoom: Self,
  //    sensitivity: Self = 0.5
  //  ) -> Self {
  //    let clampedResponse = min(max(sensitivity, 0), 1)
  //    let adjusted: Self = self * Self(pow(Double(zoom), Double(clampedResponse) - 1))
  //    return adjusted
  //  }

  /// Applies non-linear zoom scaling to provide better control at different zoom levels
  /// - Parameters:
  ///   - zoomLevel: The current zoom level (0.1...60)
  ///   - zoomRange: The valid zoom range
  ///   - lowSensitivityThreshold: Zoom level below which sensitivity is reduced (default: 1.0)
  ///   - highSensitivityThreshold: Zoom level above which sensitivity is increased (default: 5.0)
  ///   - curve: The power curve factor (default: 1.5). Higher values = more dramatic curve
  /// - Returns: The transformed zoom scale to apply to the view
  public static func nonLinearZoomScale(
    zoomLevel: Double,
    zoomRange: ClosedRange<Double>,
    lowSensitivityThreshold: Double = 1.0,
    highSensitivityThreshold: Double = 5.0,
    curve: Double = 1.5
  ) -> Double {

    // Clamp the zoom level to the valid range
    let clampedZoom = min(max(zoomLevel, zoomRange.lowerBound), zoomRange.upperBound)

    // Normalize the zoom level to 0...1 range
    let normalizedZoom = (clampedZoom - zoomRange.lowerBound) / (zoomRange.upperBound - zoomRange.lowerBound)

    // Calculate threshold positions in normalized space
    let lowThresholdNorm =
      (lowSensitivityThreshold - zoomRange.lowerBound) / (zoomRange.upperBound - zoomRange.lowerBound)
    let highThresholdNorm =
      (highSensitivityThreshold - zoomRange.lowerBound) / (zoomRange.upperBound - zoomRange.lowerBound)

    let transformedZoom: Double

    if normalizedZoom <= lowThresholdNorm {
      // Low zoom range: reduce sensitivity (expand the curve - slower response)
      let localNorm = normalizedZoom / lowThresholdNorm
      let expanded = pow(localNorm, curve)  // Use curve to slow down response
      transformedZoom = expanded * lowThresholdNorm

    } else if normalizedZoom >= highThresholdNorm {
      // High zoom range: increase sensitivity (compress the curve - faster response)
      let localNorm = (normalizedZoom - highThresholdNorm) / (1.0 - highThresholdNorm)
      let compressed = pow(localNorm, 1.0 / curve)  // Inverse curve for faster response
      transformedZoom = highThresholdNorm + compressed * (1.0 - highThresholdNorm)

    } else {
      // Middle range: linear scaling
      transformedZoom = normalizedZoom
    }

    // Convert back to actual zoom range
    return transformedZoom * (zoomRange.upperBound - zoomRange.lowerBound) + zoomRange.lowerBound
  }

  /// Simplified non-linear zoom scaling using a single curve parameter
  /// - Parameters:
  ///   - zoomLevel: The current zoom level
  ///   - zoomRange: The valid zoom range
  ///   - sensitivity: Controls the curve (values < 1.0 = less sensitive at low zoom, values > 1.0 = more sensitive at low zoom)
  /// - Returns: The transformed zoom scale
  public static func simpleNonLinearZoomScale(
    zoomLevel: Double,
    zoomRange: ClosedRange<Double>,
    sensitivity: Double = 1.3
  ) -> Double {
    let clampedZoom = min(max(zoomLevel, zoomRange.lowerBound), zoomRange.upperBound)
    let normalizedZoom = (clampedZoom - zoomRange.lowerBound) / (zoomRange.upperBound - zoomRange.lowerBound)
    let transformedZoom = pow(normalizedZoom, sensitivity)
    return transformedZoom * (zoomRange.upperBound - zoomRange.lowerBound) + zoomRange.lowerBound
  }

  public func toPercentString(within range: ClosedRange<Self>) -> String {
    let normalised: Double = Double(self.normalised(from: range))
    return String(normalised.formatted(.percent.precision(.fractionLength(0))))
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

  public var constrainedOpacity: Self {
    return min(1.0, max(0.0, self))
  }

  public var isPositive: Bool {
    self > 0
  }

  //  public func normalised(
  //    against value: Double,
  //    isClamped: Bool = true
  //  ) -> Double {
  //
  //    guard let doubleValue = self as? Double else {
  //      return CGFloat(self) / value
  //    }
  //    return doubleValue / value
  //  }

  public var toFinite: Self {
    self.clamped(.zero, .infinity)
  }

  public var isGreaterThanZero: Bool {
    self > 0
  }

  //  public func padLeading(
  //    maxDigits: Int = 3,
  //    decimalPlaces: Int? = nil,
  //    with padChar: Character = " "
  //  ) -> String {
  //
  //    guard let double = self as? Double else {
  //      return PadFloat.padLeading(
  //        value: CGFloat(self),
  //        maxDigits: maxDigits,
  //        decimalPlaces: decimalPlaces,
  //        with: padChar
  //      )
  //    }
  //    return PadFloat.padLeading(
  //      value: double,
  //      maxDigits: maxDigits,
  //      decimalPlaces: decimalPlaces,
  //      with: padChar
  //    )
  //
  //  }

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

//
//  Lerp.swift
//
//  Written by Ramon Torres
//  Placed under public domain.
//

/// Code courtesy of https://rtorres.me/blog/lerp-swift/
/// Linearly interpolates between two values.
///
/// Interpolates between the values `v0` and `v1` by a factor `t`.
///
/// - Parameters:
///   - v0: The first value.
///   - v1: The second value.
///   - t: The interpolation factor. Between `0` and `1`.
/// - Returns: The interpolated value.
@inline(__always)
public func lerp<V: BinaryFloatingPoint, T: BinaryFloatingPoint>(from v0: V, to v1: V, _ t: T) -> V {
  return v0 + V(t) * (v1 - v0)
}

/// Linearly interpolates between two points.
///
/// Interpolates between the points `p0` and `p1` by a factor `t`.
///
/// - Parameters:
///   - p0: The first point.
///   - p1: The second point.
///   - t: The interpolation factor. Between `0` and `1`.
/// - Returns: The interpolated point.
@inline(__always)
public func lerp<T: BinaryFloatingPoint>(from p0: CGPoint, to p1: CGPoint, _ t: T) -> CGPoint {
  return CGPoint(
    x: lerp(from: p0.x, to: p1.x, t),
    y: lerp(from: p0.y, to: p1.y, t)
  )
}

/// Linearly interpolates between two sizes.
///
/// Interpolates between the sizes `s0` and `s1` by a factor `t`.
///
/// - Parameters:
///   - s0: The first size.
///   - s1: The second size.
///   - t: The interpolation factor. Between `0` and `1`.
/// - Returns: The interpolated size.
@inline(__always)
public func lerp<T: BinaryFloatingPoint>(from s0: CGSize, to s1: CGSize, _ t: T) -> CGSize {
  return CGSize(
    width: lerp(from: s0.width, to: s1.width, t),
    height: lerp(from: s0.height, to: s1.height, t)
  )
}

/// Linearly interpolates between two rectangles.
///
/// Interpolates between the rectangles `r0` and `r1` by a factor `t`.
///
/// - Parameters:
///   - r0: The first rectangle.
///   - r1: The second rectangle.
///   - t: The interpolation factor. Between `0` and `1`.
/// - Returns: The interpolated rectangle.
@inline(__always)
public func lerp<T: BinaryFloatingPoint>(from r0: CGRect, to r1: CGRect, _ t: T) -> CGRect {
  return CGRect(
    origin: lerp(from: r0.origin, to: r1.origin, t),
    size: lerp(from: r0.size, to: r1.size, t)
  )
}

/// Inverse linear interpolation.
///
/// Given a value `v` between `v0` and `v1`, returns the interpolation factor `t`
/// such that `v == lerp(v0, v1, t)`.
///
/// - Parameters:
///   - v0: The lower bound of the interpolation range.
///   - v1: The upper bound of the interpolation range.
///   - v: The value to interpolate.
/// - Returns: The interpolation factor `t` such that `v == lerp(v0, v1, t)`.
@inline(__always)
public func inverseLerp<V: BinaryFloatingPoint, T: BinaryFloatingPoint>(_ v0: V, _ v1: V, _ v: V) -> T {
  return T((v - v0) / (v1 - v0))
}

// swiftlint:enable identifier_name

//struct PadFloat {
//
//  /// Adds leading padding to align numbers based on their integer part
//  static func padLeading(
//    value: Double,
//    maxDigits: Int = 3,
//    decimalPlaces: Int? = nil,
//    with padChar: Character = " "
//  ) -> String {
//
//    let maxDigitsIncludingNegativeSign = maxDigits + 1
//
//    /// First handle decimal places if specified
//    let numberToFormat = value
//    let formattedNumber: String
//
//    if let places = decimalPlaces {
//      formattedNumber = numberToFormat.formatted(.number.precision(.fractionLength(places)))
//    } else {
//      formattedNumber = String(numberToFormat)
//    }
//
//    let isNegative = numberToFormat < 0
//
//    /// Split into components, handling the negative sign
//    let absNumberStr = isNegative ? String(formattedNumber.dropFirst()) : formattedNumber
//    let components = absNumberStr.split(separator: ".", maxSplits: 1)
//    let integerPart = String(components[0])
//    let decimalPart = components.count > 1 ? "." + components[1] : ""
//
//    /// Calculate padding needed, accounting for negative sign
//    let effectiveLength = integerPart.count + (isNegative ? 1 : 0)
//    let padding = String(repeating: padChar, count: max(0, maxDigitsIncludingNegativeSign - effectiveLength))
//
//    /// Reconstruct the string with proper padding and sign
//    guard isNegative else {
//      return padding + integerPart + decimalPart
//    }
//    return padding + "-" + integerPart + decimalPart
//  }
//
//}
