//
//  BinaryFloatingPoint.swift
//  Helpers
//
//  Created by Dave Coleman on 31/8/2024.
//

import Foundation


public extension Double {
  /// Adds leading padding to align numbers based on their integer part
  /// - Parameters:
  ///   - maxDigits: Maximum number of digits to pad to
  ///   - padChar: Character to use for padding (default: space)
  /// - Returns: String with appropriate padding
  func padLeading(maxDigits: Int, with padChar: Character = " ") -> String {
    let numberStr = String(self)
    let isNegative = self < 0
    
    /// Split into components, handling the negative sign
    let absNumberStr = isNegative ? String(numberStr.dropFirst()) : numberStr
    let components = absNumberStr.split(separator: ".", maxSplits: 1)
    let integerPart = String(components[0])
    let decimalPart = components.count > 1 ? "." + components[1] : ""
    
    /// Calculate padding needed, accounting for negative sign
    let effectiveLength = integerPart.count + (isNegative ? 1 : 0)
    let padding = String(repeating: padChar, count: max(0, maxDigits - effectiveLength))
    
    /// Reconstruct the string with proper padding and sign
    if isNegative {
      return padding + "-" + integerPart + decimalPart
    } else {
      return padding + integerPart + decimalPart
    }
  }
  
  
  func toDecimal(_ places: Int = 2) -> String {
    floatToDecimal(value: self, places: places)
  }
  
  var toInt: String {
    floatToDecimal(value: self, places: 0)
  }
}

public extension CGFloat {
  
  func padLeading(maxDigits: Int, with padChar: Character = " ") -> String {
    Double(self).padLeading(maxDigits: maxDigits, with: padChar)
  }
  
  var toDecimal: String {
    toDecimal()
  }
  
  func toDecimal(_ places: Int = 2) -> String {
    floatToDecimal(value: self, places: places)
  }
  
  var toInt: String {
    floatToDecimal(value: self, places: 0)
  }
  
  var isPositive: Bool {
    self > 0
  }
  
  func normalised(against value: CGFloat, isClamped: Bool = true) -> CGFloat {
    let normalised = self / value
    
    return normalised
  }
  
}


func floatToDecimal<T: BinaryFloatingPoint>(value: T, places: Int) -> String {
  let doubleValue = Double(value)
  let formatted = doubleValue.formatted(.number.precision(.fractionLength(places)))
  return String(formatted)
}





//public extension Double {
//  var wholeNumber: String {
//    return toDecimalPlace(self, to: 0)
//  }
//  func toDecimal(_ place: Int) -> String {
//    return toDecimalPlace(self, to: place)
//  }
//}




public extension CGSize {
  var widthOrHeightIsZero: Bool {
    return self.width.isZero || self.height.isZero
  }
}



// Extension for Float
//public extension Float {
//  /// Returns a string representation of the number with specified decimal places
//  /// - Parameter decimalPlaces: Number of decimal places to round to
//  /// - Parameter minimumDecimalPlaces: Minimum number of decimal places to show (defaults to same as decimalPlaces)
//  /// - Returns: Formatted string with specified decimal places
//  func toString(decimalPlaces: Int = 0, minimumDecimalPlaces: Int? = nil) -> String {
//    let numberFormatter = NumberFormatter()
//    numberFormatter.numberStyle = .decimal
//    numberFormatter.maximumFractionDigits = decimalPlaces
//    numberFormatter.minimumFractionDigits = minimumDecimalPlaces ?? decimalPlaces
//    return numberFormatter.string(from: NSNumber(value: self)) ?? String(self)
//  }
//  
//  /// Returns a string representation of the number with specified decimal places and optional grouping separator
//  /// - Parameter decimalPlaces: Number of decimal places to round to
//  /// - Parameter useGroupingSeparator: Whether to use thousand separators (defaults to false)
//  /// - Returns: Formatted string with specified decimal places
//  func toString(decimalPlaces: Int = 0, useGroupingSeparator: Bool) -> String {
//    let numberFormatter = NumberFormatter()
//    numberFormatter.numberStyle = .decimal
//    numberFormatter.maximumFractionDigits = decimalPlaces
//    numberFormatter.minimumFractionDigits = decimalPlaces
//    numberFormatter.usesGroupingSeparator = useGroupingSeparator
//    return numberFormatter.string(from: NSNumber(value: self)) ?? String(self)
//  }
//}
//
//// Extension for Double
//public extension Double {
//  /// Returns a string representation of the number with specified decimal places
//  /// - Parameter decimalPlaces: Number of decimal places to round to
//  /// - Parameter minimumDecimalPlaces: Minimum number of decimal places to show (defaults to same as decimalPlaces)
//  /// - Returns: Formatted string with specified decimal places
//  func toString(decimalPlaces: Int = 0, minimumDecimalPlaces: Int? = nil) -> String {
//    let numberFormatter = NumberFormatter()
//    numberFormatter.numberStyle = .decimal
//    numberFormatter.maximumFractionDigits = decimalPlaces
//    numberFormatter.minimumFractionDigits = minimumDecimalPlaces ?? decimalPlaces
//    return numberFormatter.string(from: NSNumber(value: self)) ?? String(self)
//  }
//  
//  /// Returns a string representation of the number with specified decimal places and optional grouping separator
//  /// - Parameter decimalPlaces: Number of decimal places to round to
//  /// - Parameter useGroupingSeparator: Whether to use thousand separators (defaults to false)
//  /// - Returns: Formatted string with specified decimal places
//  func toString(decimalPlaces: Int = 0, useGroupingSeparator: Bool) -> String {
//    let numberFormatter = NumberFormatter()
//    numberFormatter.numberStyle = .decimal
//    numberFormatter.maximumFractionDigits = decimalPlaces
//    numberFormatter.minimumFractionDigits = decimalPlaces
//    numberFormatter.usesGroupingSeparator = useGroupingSeparator
//    return numberFormatter.string(from: NSNumber(value: self)) ?? String(self)
//  }
//}

// Extension for CGFloat
//extension CGFloat {
  /// Returns a string representation of the number with specified decimal places
  /// - Parameter decimalPlaces: Number of decimal places to round to
  /// - Parameter minimumDecimalPlaces: Minimum number of decimal places to show (defaults to same as decimalPlaces)
  /// - Returns: Formatted string with specified decimal places
//  func toString(decimalPlaces: Int, minimumDecimalPlaces: Int? = nil) -> String {
//    let numberFormatter = NumberFormatter()
//    numberFormatter.numberStyle = .decimal
//    numberFormatter.maximumFractionDigits = decimalPlaces
//    numberFormatter.minimumFractionDigits = minimumDecimalPlaces ?? decimalPlaces
//    return numberFormatter.string(from: NSNumber(value: Double(self))) ?? String(self)
//  }
//  
//  /// Returns a string representation of the number with specified decimal places and optional grouping separator
//  /// - Parameter decimalPlaces: Number of decimal places to round to
//  /// - Parameter useGroupingSeparator: Whether to use thousand separators (defaults to false)
//  /// - Returns: Formatted string with specified decimal places
//  func toString(decimalPlaces: Int, useGroupingSeparator: Bool) -> String {
//    let numberFormatter = NumberFormatter()
//    numberFormatter.numberStyle = .decimal
//    numberFormatter.maximumFractionDigits = decimalPlaces
//    numberFormatter.minimumFractionDigits = decimalPlaces
//    numberFormatter.usesGroupingSeparator = useGroupingSeparator
//    return numberFormatter.string(from: NSNumber(value: Double(self))) ?? String(self)
//  }
//}
