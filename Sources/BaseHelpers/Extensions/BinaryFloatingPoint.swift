//
//  BinaryFloatingPoint.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 27/2/2025.
//

import Foundation

extension BinaryFloatingPoint {
  
  public func clamped(toIntRange range: Range<Int>) -> Self {
    return clamped(Self(range.lowerBound), Self(range.upperBound))
  }

  public func displayString(
    _ decimalPlaces: Int = 2,
    grouping: FloatingPointFormatStyle<Self>.Configuration.Grouping = .automatic
  ) -> String {
    let doubleValue = Double(self)
    let formatted = doubleValue.formatted(.number.precision(.fractionLength(decimalPlaces)).grouping(grouping))
    return String(formatted)
  }

  public var displayString: String {
    return self.displayString()
  }

  public var toInt: String {
    self.displayString(0)
    //    floatToString(value: self, places: 0)
  }
  
  public init(
    _ value: Self,
    removingZoom zoom: Self,
    with sensitivity: Self = 0.5
  ) {
    let clampedSensitivity = Double(sensitivity.clamped(to: 0...1))
    let adjusted = value * Self(pow(Double(zoom), clampedSensitivity - 1))
    self.init(adjusted)
  }

  public func removingZoom(_ zoom: Self) -> Self {
    return self / zoom
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

  public func normalised(
    against value: Double,
    isClamped: Bool = true
  ) -> Double {

    guard let doubleValue = self as? Double else {
      return CGFloat(self) / value
    }
    return doubleValue / value
  }

  public var toFinite: Double {
    Double(self.clamped(.zero, .infinity))
  }


  public func padLeading(
    maxDigits: Int = 3,
    decimalPlaces: Int? = nil,
    with padChar: Character = " "
  ) -> String {

    guard let double = self as? Double else {
      return PadFloat.padLeading(
        value: CGFloat(self),
        maxDigits: maxDigits,
        decimalPlaces: decimalPlaces,
        with: padChar
      )
    }
    return PadFloat.padLeading(
      value: double,
      maxDigits: maxDigits,
      decimalPlaces: decimalPlaces,
      with: padChar
    )

  }

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

struct PadFloat {

  /// Adds leading padding to align numbers based on their integer part
  static func padLeading(
    value: Double,
    maxDigits: Int = 3,
    decimalPlaces: Int? = nil,
    with padChar: Character = " "
  ) -> String {

    let maxDigitsIncludingNegativeSign = maxDigits + 1

    /// First handle decimal places if specified
    let numberToFormat = value
    let formattedNumber: String

    if let places = decimalPlaces {
      formattedNumber = numberToFormat.formatted(.number.precision(.fractionLength(places)))
    } else {
      formattedNumber = String(numberToFormat)
    }

    let isNegative = numberToFormat < 0

    /// Split into components, handling the negative sign
    let absNumberStr = isNegative ? String(formattedNumber.dropFirst()) : formattedNumber
    let components = absNumberStr.split(separator: ".", maxSplits: 1)
    let integerPart = String(components[0])
    let decimalPart = components.count > 1 ? "." + components[1] : ""

    /// Calculate padding needed, accounting for negative sign
    let effectiveLength = integerPart.count + (isNegative ? 1 : 0)
    let padding = String(repeating: padChar, count: max(0, maxDigitsIncludingNegativeSign - effectiveLength))

    /// Reconstruct the string with proper padding and sign
    guard isNegative else {
      return padding + integerPart + decimalPart
    }
    return padding + "-" + integerPart + decimalPart
  }

}
