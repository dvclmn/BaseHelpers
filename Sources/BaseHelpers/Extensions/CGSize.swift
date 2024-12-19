//
//  CGSize.swift
//  Collection
//
//  Created by Dave Coleman on 12/11/2024.
//

import Foundation

// MARK: - Multiplication
infix operator *: MultiplicationPrecedence

public func *(lhs: CGSize, rhs: CGFloat) -> CGSize {
  return CGSize(
    width: lhs.width * rhs,
    height: lhs.height * rhs
  )
}

public extension CGSize {
  /// Returns true if both width and height are greater than zero
  var isPositive: Bool {
    return width > 0 && height > 0
  }
  
  /// Returns true if either width or height is zero or negative
  var isZeroOrNegative: Bool {
    return !isPositive
  }
  
  /// Returns true if both width and height are greater than or equal to zero
  var isNonNegative: Bool {
    return width >= 0 && height >= 0
  }
  
  var centrePoint: CGPoint {
    return CGPoint(x: width / 2, y: height / 2)
  }
  
  func displayString(decimalPlaces: Int = 2, style: StringStyle = .short) -> String {
    
    let width: String = "\(self.width.toDecimal(decimalPlaces))"
    let height: String = "\(self.height.toDecimal(decimalPlaces))"
    
    switch style {
      case .short:
        return "\(width) x \(height)"
        
      case .initials:
        return "W \(width)  H \(height)"
        
      case .full:
        return "Width \(width)  Height \(height)"
    }
  }
  
  @available(*, deprecated, message: "This function is deprecated. Use `displayString` instead")
  var asString: String {
    return "Width: \(width.padLeading(maxDigits: 3, decimalPlaces: 2)) x Height: \(height.padLeading(maxDigits: 3, decimalPlaces: 2))"
  }
  
  enum StringStyle {
    case short
    case initials
    case full
  }
}
