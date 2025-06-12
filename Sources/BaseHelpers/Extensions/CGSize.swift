//
//  CGSize.swift
//  Collection
//
//  Created by Dave Coleman on 12/11/2024.
//

import SwiftUI



extension CGSize {
  
  /// Strategy for handling views that are larger than their container
  public enum PlacementStrategy {
    /// Center the view within the container, allowing overflow
    case centerWithOverflow
    /// Scale the view proportionally to fit within the container
    case scaleToFit
    /// Scale the view to fill the container, potentially cropping content
    case scaleToFill
    /// Align to top-left corner, allowing overflow
    case topLeft
    /// Align to top-right corner, allowing overflow
    case topRight
    /// Align to bottom-left corner, allowing overflow
    case bottomLeft
    /// Align to bottom-right corner, allowing overflow
    case bottomRight
    /// Return nil if the view doesn't fit (original behavior)
//    case failIfOversized
  }
  
  /// Creates a CGRect for this size positioned within the given container size
  /// - Parameters:
  ///   - containerSize: The size of the container view
  ///   - strategy: How to handle cases where this size is larger than the container
  /// - Returns: A CGRect positioned according to the strategy, or nil if strategy is failIfOversized and view is too large
  public func toCGRect(
    in containerSize: CGSize,
    strategy: PlacementStrategy = .centerWithOverflow
  ) -> CGRect {
    
    switch strategy {
//      case .failIfOversized:
//        guard containerSize >= self else {
//          print("Attempting to place a view within a smaller parent view is not yet supported.")
//          return nil
//        }
//        return centeredRect(in: containerSize, with: self)
        
      case .centerWithOverflow:
        return centeredRect(in: containerSize, with: self)
        
      case .scaleToFit:
        let scaledSize = self.aspectFitSize(in: containerSize)
        return centeredRect(in: containerSize, with: scaledSize)
        
      case .scaleToFill:
        let scaledSize = self.aspectFillSize(in: containerSize)
        return centeredRect(in: containerSize, with: scaledSize)
        
      case .topLeft:
        return CGRect(origin: .zero, size: self)
        
      case .topRight:
        return CGRect(x: containerSize.width - width, y: 0, width: width, height: height)
        
      case .bottomLeft:
        return CGRect(x: 0, y: containerSize.height - height, width: width, height: height)
        
      case .bottomRight:
        return CGRect(x: containerSize.width - width, y: containerSize.height - height, width: width, height: height)
    }
  }
  
  public static let trackpad = CGSize(
    width: 700,
    height: 438
  )
  
//  public func centeredIn(viewSize: CGSize) -> CGSize {
//    
//    let viewMid = viewSize.midpoint
//    let selfMid = self.midpoint
//
//    let newOrigin = CGPoint(
//      x: viewMid.x - selfMid.x,
//      y: viewMid.y - selfMid.y
//    )
//    
//    return CGRect(
//      x: newOrigin.x,
//      y: newOrigin.y,
//      width: self.width,
//      height: self.height
//    )
//  }
//  
//  public func reallyCentredIn(viewSize: CGSize) -> CGPoint {
//    self.centeredIn(viewSize: viewSize).center
//  }

  
  private func centeredRect(
    in containerSize: CGSize,
    with size: CGSize
  ) -> CGRect {
    let x = (containerSize.width - size.width) / 2
    let y = (containerSize.height - size.height) / 2
    return CGRect(x: x, y: y, width: size.width, height: size.height)
  }
  
  private func aspectFitSize(in containerSize: CGSize) -> CGSize {
    let widthRatio = containerSize.width / width
    let heightRatio = containerSize.height / height
    let scale = min(widthRatio, heightRatio)
    
    return CGSize(width: width * scale, height: height * scale)
  }
  
  private func aspectFillSize(in containerSize: CGSize) -> CGSize {
    let widthRatio = containerSize.width / width
    let heightRatio = containerSize.height / height
    let scale = max(widthRatio, heightRatio)
    
    return CGSize(width: width * scale, height: height * scale)
  }
  
  public func lengthForAxis(_ axis: Axis) -> CGFloat {
    axis == .horizontal ? width : height
  }
  
  public var toCGRectZeroOrigin: CGRect {
    CGRect(origin: .zero, size: self)
  }

//  public func toCGRect(centredIn viewSize: CGSize) -> CGRect? {
//    
//    guard viewSize > self else {
//      print("Attempting to place a view within a smaller parent view is not yet supported.")
//      return nil
//    }
//    
//    let x = (viewSize.width - width) / 2
//    let y = (viewSize.height - height) / 2
//    return CGRect(x: x, y: y, width: width, height: height)
//  }
//  
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
    let result = CGPoint(
      x: self.width / 2,
      y: self.height / 2
    )
    precondition(!result.isNan || result.isFinite, "Don't want to thing the thing")
    return result
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
  let result = CGSize(
    width: lhs.width * rhs,
    height: lhs.height * rhs
  )
  precondition(result.width > 0 && result.height > 0, "Cannot have a size with width or height less than or equal to zero")
  return result
  
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

infix operator >=: ComparisonPrecedence
/// Returns true if both width and height are greater than or equal to the compared size
public func >=(lhs: CGSize, rhs: CGSize) -> Bool {
  return lhs.width >= rhs.width && lhs.height >= rhs.height
}
