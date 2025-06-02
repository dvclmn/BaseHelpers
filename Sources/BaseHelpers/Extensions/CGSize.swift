//
//  CGSize.swift
//  Collection
//
//  Created by Dave Coleman on 12/11/2024.
//

import SwiftUI



extension CGSize {
  
  public func lengthForAxis(_ axis: Axis) -> CGFloat {
    axis == .horizontal ? width : height
  }
  
  public var toCGRect: CGRect {
    CGRect(origin: .zero, size: self)
  }

  public func toCGRect(centredIn viewSize: CGSize) -> CGRect? {
    
    guard viewSize > self else {
      print("Attempting to place a view within a smaller parent view is not yet supported.")
      return nil
    }
    
    let x = (viewSize.width - width) / 2
    let y = (viewSize.height - height) / 2
    return CGRect(x: x, y: y, width: width, height: height)
  }
  
//  func centeredRect(in viewSize: CGSize) -> CGRect {
//    let x = (viewSize.width - width) / 2
//    let y = (viewSize.height - height) / 2
//    return CGRect(x: x, y: y, width: width, height: height)
//  }
  
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

  public var midpoint: CGPoint {
    centrePoint
  }
  
  public var centrePoint: CGPoint {
    CGPoint(x: width / 2, y: height / 2)
  }


  public var widthOrHeightIsZero: Bool {
    self.width.isZero || self.height.isZero
  }

  public var displayString: String {
    displayString()
  }

  public func displayString(decimalPlaces: Int = 2, style: DisplayStringStyle = .short) -> String {

    let width: String = "\(self.width.displayString(decimalPlaces))"
    let height: String = "\(self.height.displayString(decimalPlaces))"

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

// MARK: - Multiplication
infix operator * : MultiplicationPrecedence

public func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
  CGSize(
    width: lhs.width * rhs,
    height: lhs.height * rhs
  )
}

// MARK: - Greater than
infix operator >: ComparisonPrecedence

public func >(lhs: CGSize, rhs: CGFloat) -> Bool {
  lhs.width > rhs || lhs.height > rhs
}

public func >(lhs: CGSize, rhs: CGSize) -> Bool {
  lhs.width > rhs.width || lhs.height > rhs.height
}


// MARK: - Less than
infix operator <: ComparisonPrecedence

public func <(lhs: CGSize, rhs: CGFloat) -> Bool {
  lhs.width < rhs || lhs.height < rhs
}
