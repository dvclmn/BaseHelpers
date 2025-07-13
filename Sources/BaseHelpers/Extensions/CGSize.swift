//
//  CGSize.swift
//  Collection
//
//  Created by Dave Coleman on 12/11/2024.
//

import SwiftUI
import Foundation



extension CGSize {
  
//  public var displayString: String {
//    self.displayString()
//  }
//  
//  public func displayString(
//    _ decimalPlaces: Int = 2,
//    grouping: Decimal.FormatStyle.Configuration.Grouping = .automatic
////    grouping: FloatingPointFormatStyle<Double>.Configuration.Grouping = .automatic
//  ) -> String {
//    
//    let width: Double = self.width
//    let height: Double = self.height
//    let formattedWidth: String = width.formatted(.number.precision(.fractionLength(decimalPlaces)).grouping(grouping))
//    let formattedHeight: String = height.formatted(.number.precision(.fractionLength(decimalPlaces)).grouping(grouping))
//    return String(formattedWidth + " x " + formattedHeight)
//  }
  
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
  
  public var halved: CGSize {
    return CGSize(width: width / 2, height: height / 2)
  }
  
  public static let trackpad = CGSize(
    width: 700,
    height: 438
  )
  
  public func removingZoom(_ zoom: CGFloat) -> CGSize {
    return self / zoom
  }
  
  public var longestDimension: CGFloat {
    return max(width, height)
  }
  public var shortestDimension: CGFloat {
    return min(width, height)
  }
  
  public init(fromLength length: CGFloat) {
    self.init(width: length, height: length)
  }

  public func value(for axis: Axis) -> CGFloat {
    switch axis {
      case .horizontal:
        return width
      case .vertical:
        return height
    }
  }
  
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
  
  /// Returns the centre point of the size, relative to a (0,0) origin
  public var midpoint: CGPoint {
    return CGPoint(x: width / 2, y: height / 2)
  }

  public var widthOrHeightIsZero: Bool {
    self.width.isZero || self.height.isZero
  }
  
  

  /// Returns a new size reduced evenly on all four sides by the specified inset value
  /// - Parameter inset: The amount to inset from all edges (width and height are each reduced by 2x this value)
  /// - Returns: A new CGSize with the inset applied
  public func inset(by inset: CGFloat) -> CGSize {
    return CGSize(
      width: max(0, width - (inset * 2)),
      height: max(0, height - (inset * 2))
    )
  }

}


// MARK: - Subtraction
infix operator - : AdditionPrecedence

public func - (lhs: CGSize, rhs: CGSize) -> CGSize {
  return CGSize(
    width: lhs.width - rhs.width,
    height: lhs.height - rhs.height
  )
}
public func - (lhs: CGSize, rhs: CGFloat) -> CGSize {
  return CGSize(
    width: lhs.width - rhs,
    height: lhs.height - rhs
  )
}
public func - (lhs: CGSize, rhs: CGPoint) -> CGSize {
  return CGSize(
    width: lhs.width - rhs.x,
    height: lhs.height - rhs.y
  )
}

public func + (lhs: CGSize, rhs: CGSize) -> CGSize {
  return CGSize(
    width: lhs.width + rhs.width,
    height: lhs.height + rhs.height
  )
}
public func + (lhs: CGSize, rhs: CGFloat) -> CGSize {
  return CGSize(
    width: lhs.width + rhs,
    height: lhs.height + rhs
  )
}

public func + (lhs: CGFloat, rhs: CGSize) -> CGSize {
  return CGSize(
    width: lhs + rhs.width,
    height: lhs + rhs.height
  )
}

public func += (lhs: inout CGSize, rhs: CGFloat) {
  lhs = lhs + rhs
}




// MARK: - Multiplication
infix operator * : MultiplicationPrecedence

public func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
  return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
}

public func positiveScale(_ size: CGSize, by factor: CGFloat) -> CGSize {
  let result = size * factor
  precondition(result.width > 0 && result.height > 0, "Scaling resulted in non-positive size")
  return result
}

//public func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
//  let result = CGSize(
//    width: lhs.width * rhs,
//    height: lhs.height * rhs
//  )
//  precondition(result.width > 0 && result.height > 0, "Cannot have a size with width or height less than or equal to zero")
//  return result
//  
//}

public func / (lhs: CGSize, rhs: CGSize) -> CGSize {
  precondition(rhs.width != 0 && rhs.height != 0, "Cannot divide by zero size")
  return CGSize(
    width: lhs.width / rhs.width,
    height: lhs.height / rhs.height
  )
}

public func / (lhs: CGSize, rhs: CGFloat) -> CGSize {
  precondition(rhs != 0 && rhs != 0, "Cannot divide by zero size")
  return CGSize(
    width: lhs.width / rhs,
    height: lhs.height / rhs
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

infix operator >=: ComparisonPrecedence
/// Returns true if both width and height are greater than or equal to the compared size
public func >=(lhs: CGSize, rhs: CGSize) -> Bool {
  return lhs.width >= rhs.width && lhs.height >= rhs.height
}
