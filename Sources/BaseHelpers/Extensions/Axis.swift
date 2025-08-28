//
//  Axis.swift
//  Collection
//
//  Created by Dave Coleman on 30/10/2024.
//

import SwiftUI

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

  /// The starting inset for the horizontal axis, given the current convention.
  public func horizontalLengthStart(_ edgeInsets: EdgeInsets) -> CGFloat {
    switch self {
      case .widthIsHorizontal:
        return edgeInsets.leading
      case .heightIsHorizontal:
        return edgeInsets.top
    }
  }
  public func horizontalLengthEnd(_ edgeInsets: EdgeInsets) -> CGFloat {
    switch self {
      case .widthIsHorizontal:
        return edgeInsets.trailing
      case .heightIsHorizontal:
        return edgeInsets.bottom
    }
  }

  public func verticalLengthStart(_ edgeInsets: EdgeInsets) -> CGFloat {
    switch self {
      case .widthIsHorizontal:
        return edgeInsets.top
      case .heightIsHorizontal:
        return edgeInsets.leading
    }
  }
  public func verticalLengthEnd(_ edgeInsets: EdgeInsets) -> CGFloat {
    switch self {
      case .widthIsHorizontal:
        return edgeInsets.bottom
      case .heightIsHorizontal:
        return edgeInsets.trailing
    }
  }

  // MARK: Final EdgeInsets methods
  public func horizontalLength(edgeInsets: EdgeInsets) -> CGFloat {
    horizontalLengthStart(edgeInsets) + horizontalLengthEnd(edgeInsets)
  }
  public func verticalLength(edgeInsets: EdgeInsets) -> CGFloat {
    verticalLengthStart(edgeInsets) + verticalLengthEnd(edgeInsets)
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

  // MARK: - CGPoint

  /// Returns the "horizontal" coordinate from a point, according to the convention.
  ///
  /// - `.widthIsHorizontal`: horizontal = `x`
  /// - `.heightIsHorizontal`: horizontal = `y`
  public func horizontalLength(point: CGPoint) -> CGFloat {
    switch self {
      case .widthIsHorizontal:
        return point.x
      case .heightIsHorizontal:
        return point.y
    }
  }

  /// Returns the "vertical" coordinate from a point, according to the convention.
  ///
  /// - `.widthIsHorizontal`: vertical = `y`
  /// - `.heightIsHorizontal`: vertical = `x`
  public func verticalLength(point: CGPoint) -> CGFloat {
    switch self {
      case .widthIsHorizontal:
        return point.y
      case .heightIsHorizontal:
        return point.x
    }
  }

  // MARK: - UnitPoint
  public func horizontalLength(unitPoint: UnitPoint) -> CGFloat {
    switch self {
      case .widthIsHorizontal:
        return unitPoint.x
      case .heightIsHorizontal:
        return unitPoint.y
    }
  }

  public func verticalLength(unitPoint: UnitPoint) -> CGFloat {
    switch self {
      case .widthIsHorizontal:
        return unitPoint.y
      case .heightIsHorizontal:
        return unitPoint.x
    }
  }
}

extension Axis {

  public var toAxisSet: Axis.Set {
    switch self {
      case .horizontal:
        return [.horizontal]
      case .vertical:
        return [.vertical]
    }
  }

  public var name: String {
    switch self {
      case .horizontal:
        "X"
      case .vertical:
        "Y"
    }
  }

  /// Returns the length for this axis from a `CGSize`,
  /// interpreting width/height according to the given convention.
  public func length(
    from size: CGSize,
    convention: DimensionToAxisConvention = .widthIsHorizontal
  ) -> CGFloat {
    switch self {
      case .horizontal:
        return convention.horizontalLength(size: size)
      case .vertical:
        return convention.verticalLength(size: size)
    }
  }

  /// Returns the coordinate for this axis from a `CGPoint`,
  /// interpreting x/y according to the given convention.
  public func length(
    from point: CGPoint,
    convention: DimensionToAxisConvention = .widthIsHorizontal
  ) -> CGFloat {
    switch self {
      case .horizontal:
        return convention.horizontalLength(point: point)
      case .vertical:
        return convention.verticalLength(point: point)
    }
  }

  /// Returns the total inset length for this axis from `EdgeInsets`,
  /// interpreting leading/trailing/top/bottom according to the given convention.
  public func length(
    from edgeInsets: EdgeInsets,
    convention: DimensionToAxisConvention = .widthIsHorizontal
  ) -> CGFloat {
    switch self {
      case .horizontal:
        return convention.horizontalLength(edgeInsets: edgeInsets)
      case .vertical:
        return convention.verticalLength(edgeInsets: edgeInsets)
    }
  }

  /// Returns the total inset length for this axis from `UnitPoint`,
  /// interpreting x/y according to the given convention.
  public func length(
    from unitPoint: UnitPoint,
    convention: DimensionToAxisConvention = .widthIsHorizontal
  ) -> CGFloat {
    switch self {
      case .horizontal:
        return convention.horizontalLength(unitPoint: unitPoint)
      case .vertical:
        return convention.verticalLength(unitPoint: unitPoint)
    }
  }

  /// Returns the total inset length for this axis from `CGRect`,
  /// interpreting width/height according to the given convention.
  public func length(
    from rect: CGRect,
    convention: DimensionToAxisConvention = .widthIsHorizontal
  ) -> CGFloat {
    switch self {
      case .horizontal:
        return convention.horizontalLength(rect: rect)
      case .vertical:
        return convention.verticalLength(rect: rect)
    }
  }

  public func midPoint(from rect: CGRect) -> CGFloat {
    switch self {
      case .horizontal: return rect.midX
      case .vertical: return rect.midY
    }
  }

  public func getMinMax(_ axis: Axis.MinMax) -> Axis {
    switch axis {
      case .minWidth, .maxWidth:
        return .horizontal

      case .minHeight, .maxHeight:
        return .vertical
    }
  }

  public enum MinMax {
    case minWidth
    case maxWidth
    case minHeight
    case maxHeight
  }

}
