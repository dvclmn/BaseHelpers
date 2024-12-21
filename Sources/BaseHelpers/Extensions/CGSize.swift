//
//  CGSize.swift
//  Collection
//
//  Created by Dave Coleman on 12/11/2024.
//

import Foundation

// MARK: - Multiplication
infix operator * : MultiplicationPrecedence

public func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
  CGSize(
    width: lhs.width * rhs,
    height: lhs.height * rhs
  )
}

extension CGSize {
  /// Returns true if both width and height are greater than zero
  public var isPositive: Bool {
    width > 0 && height > 0
  }

  /// Returns true if either width or height is zero or negative
  public var isZeroOrNegative: Bool {
    !isPositive
  }

  /// Returns true if both width and height are greater than or equal to zero
  public var isNonNegative: Bool {
    width >= 0 && height >= 0
  }

  public var centrePoint: CGPoint {
    CGPoint(x: width / 2, y: height / 2)
  }


  public var widthOrHeightIsZero: Bool {
    self.width.isZero || self.height.isZero
  }


  public func displayString(decimalPlaces: Int = 2, style: DisplayStringStyle = .short) -> String {

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
  public var asString: String {
    "Width: \(width.padLeading(maxDigits: 3, decimalPlaces: 2)) x Height: \(height.padLeading(maxDigits: 3, decimalPlaces: 2))"
  }

}
public enum DisplayStringStyle {
  case short
  case initials
  case full
}
