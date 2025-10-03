//
//  Model+AxisConvention.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 11/9/2025.
//

import SwiftUI

//public protocol AxisFromConvention {
//
//}

/// A mapping between `Dimension` (width / height) and `Axis` (horizontal / vertical).
///
/// Why this exists:
/// - In most cases, "width" means "horizontal" and "height" means "vertical".
/// - But when working with rotated coordinate systems, swapped axes, or certain
///   drawing transforms, this assumption can break.
/// - This enum explicitly records which dimension is *considered* horizontal
///   in the current coordinate system.
///
/// - `.widthIsHorizontal`:
///     width → horizontal length
///     height → vertical length
///
/// - `.heightIsHorizontal`:
///     height → horizontal length
///     width → vertical length
///
/// This mapping lets you correctly interpret values from `CGSize`, `CGPoint`,
/// `EdgeInsets`, etc., without making incorrect assumptions.
public enum DimensionToAxisConvention {

  case widthIsHorizontal
  case heightIsHorizontal

  // MARK: - EdgeInsets Helpers
  public func horizontalLength(edgeInsets: EdgeInsets) -> CGFloat {
    switch self {
      case .widthIsHorizontal: return edgeInsets.leading + edgeInsets.trailing
      case .heightIsHorizontal: return edgeInsets.top + edgeInsets.bottom
    }
  }

  public func verticalLength(edgeInsets: EdgeInsets) -> CGFloat {
    switch self {
      case .widthIsHorizontal: return edgeInsets.top + edgeInsets.bottom
      case .heightIsHorizontal: return edgeInsets.leading + edgeInsets.trailing
    }
  }

  // MARK: - CGSize

  /// Returns the horizontal length from a size, according to the convention.
  public func horizontalLength(size: CGSize) -> CGFloat {
    switch self {
      case .widthIsHorizontal:
        return size.width
      case .heightIsHorizontal:
        return size.height
    }
  }

  /// Returns the vertical length from a size, according to the convention.
  public func verticalLength(size: CGSize) -> CGFloat {
    switch self {
      case .widthIsHorizontal:
        return size.height
      case .heightIsHorizontal:
        return size.width
    }
  }

  // MARK: - CGRect

  /// Returns the horizontal length from a size, according to the convention.
  public func horizontalLength(rect: CGRect) -> CGFloat {
    switch self {
      case .widthIsHorizontal:
        return rect.size.width
      case .heightIsHorizontal:
        return rect.size.height
    }
  }

  /// Returns the vertical length from a size, according to the convention.
  public func verticalLength(rect: CGRect) -> CGFloat {
    switch self {
      case .widthIsHorizontal:
        return rect.size.height
      case .heightIsHorizontal:
        return rect.size.width
    }
  }

  #warning("I'm not convinced that CGPoint or UnitPoint make sense within this concept. Hidden for now.")

  // MARK: - CGPoint

  /// Returns the "horizontal" coordinate from a point, according to the convention.
  ///
  /// - `.widthIsHorizontal`: horizontal = `x`
  /// - `.heightIsHorizontal`: horizontal = `y`
  //  public func horizontalLength(point: CGPoint) -> CGFloat {
  //    switch self {
  //      case .widthIsHorizontal:
  //        return point.x
  //      case .heightIsHorizontal:
  //        return point.y
  //    }
  //  }

  /// Returns the "vertical" coordinate from a point, according to the convention.
  ///
  /// - `.widthIsHorizontal`: vertical = `y`
  /// - `.heightIsHorizontal`: vertical = `x`
  //  public func verticalLength(point: CGPoint) -> CGFloat {
  //    switch self {
  //      case .widthIsHorizontal:
  //        return point.y
  //      case .heightIsHorizontal:
  //        return point.x
  //    }
  //  }

  // MARK: - UnitPoint
  //  public func horizontalLength(unitPoint: UnitPoint) -> CGFloat {
  //    switch self {
  //      case .widthIsHorizontal:
  //        return unitPoint.x
  //      case .heightIsHorizontal:
  //        return unitPoint.y
  //    }
  //  }

  //  public func verticalLength(unitPoint: UnitPoint) -> CGFloat {
  //    switch self {
  //      case .widthIsHorizontal:
  //        return unitPoint.y
  //      case .heightIsHorizontal:
  //        return unitPoint.x
  //    }
  //  }
}
