//
//  BinaryFloatingPoint.swift
//  Helpers
//
//  Created by Dave Coleman on 31/8/2024.
//

import Foundation


public extension BinaryFloatingPoint {
  
//  var wholeNumber: String {
//    return toDecimalPlace(self, to: 0)
//  }
//  func toDecimal(_ place: Int = 0) -> String {
//    return toDecimalPlace(self, to: place)
//  }
//  private func toDecimalPlace<T: FloatingPoint>(_ value: T, to decimalPlace: Int) -> String {
//    
////    guard let value = value as? CVarArg else { return "" }
//    let result = String(format: "%.\(decimalPlace)f", value as! CVarArg)
//    
//    return result
//  }
  
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

import Foundation

// Extension for Float
public extension Float {
  /// Returns a string representation of the number with specified decimal places
  /// - Parameter decimalPlaces: Number of decimal places to round to
  /// - Parameter minimumDecimalPlaces: Minimum number of decimal places to show (defaults to same as decimalPlaces)
  /// - Returns: Formatted string with specified decimal places
  func toString(decimalPlaces: Int = 0, minimumDecimalPlaces: Int? = nil) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = decimalPlaces
    numberFormatter.minimumFractionDigits = minimumDecimalPlaces ?? decimalPlaces
    return numberFormatter.string(from: NSNumber(value: self)) ?? String(self)
  }
  
  /// Returns a string representation of the number with specified decimal places and optional grouping separator
  /// - Parameter decimalPlaces: Number of decimal places to round to
  /// - Parameter useGroupingSeparator: Whether to use thousand separators (defaults to false)
  /// - Returns: Formatted string with specified decimal places
  func toString(decimalPlaces: Int = 0, useGroupingSeparator: Bool) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = decimalPlaces
    numberFormatter.minimumFractionDigits = decimalPlaces
    numberFormatter.usesGroupingSeparator = useGroupingSeparator
    return numberFormatter.string(from: NSNumber(value: self)) ?? String(self)
  }
}

// Extension for Double
public extension Double {
  /// Returns a string representation of the number with specified decimal places
  /// - Parameter decimalPlaces: Number of decimal places to round to
  /// - Parameter minimumDecimalPlaces: Minimum number of decimal places to show (defaults to same as decimalPlaces)
  /// - Returns: Formatted string with specified decimal places
  func toString(decimalPlaces: Int = 0, minimumDecimalPlaces: Int? = nil) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = decimalPlaces
    numberFormatter.minimumFractionDigits = minimumDecimalPlaces ?? decimalPlaces
    return numberFormatter.string(from: NSNumber(value: self)) ?? String(self)
  }
  
  /// Returns a string representation of the number with specified decimal places and optional grouping separator
  /// - Parameter decimalPlaces: Number of decimal places to round to
  /// - Parameter useGroupingSeparator: Whether to use thousand separators (defaults to false)
  /// - Returns: Formatted string with specified decimal places
  func toString(decimalPlaces: Int = 0, useGroupingSeparator: Bool) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = decimalPlaces
    numberFormatter.minimumFractionDigits = decimalPlaces
    numberFormatter.usesGroupingSeparator = useGroupingSeparator
    return numberFormatter.string(from: NSNumber(value: self)) ?? String(self)
  }
}

// Extension for CGFloat
extension CGFloat {
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
}
