//
//  BinaryFloatingPoint.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 27/2/2025.
//

import Foundation

extension BinaryFloatingPoint {
  
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
    Double(self.constrained(.zero, .infinity))
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
  
}

extension CGFloat {
  public var toDegrees: CGFloat {
    /// Convert radians to degrees
    return self * 180 / .pi
  }
}

extension Double {
  public var toDegrees: Double {
    /// Convert radians to degrees
    return self * 180 / .pi
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
