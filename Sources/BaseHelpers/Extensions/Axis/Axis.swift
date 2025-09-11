//
//  Axis.swift
//  Collection
//
//  Created by Dave Coleman on 30/10/2024.
//

import SwiftUI

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

  public func midPoint(from rect: CGRect) -> CGFloat {
    switch self {
      case .horizontal: return rect.midX
      case .vertical: return rect.midY
    }
  }

  #warning("Does this make sense? Should this be incorporated with `DimensionToAxisConvention`?")
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

  /// Returns the length for this axis from a `CGSize`,
  /// interpreting width/height according to the given convention.
  public func length(
    fromSize size: CGSize,
    convention: DimensionToAxisConvention = .widthIsHorizontal
  ) -> CGFloat {
    switch self {
      case .horizontal:
        return convention.horizontalLength(size: size)
      case .vertical:
        return convention.verticalLength(size: size)
    }
  }

  /// Returns the total inset length for this axis from `CGRect`,
  /// interpreting width/height according to the given convention.
  public func length(
    fromRect rect: CGRect,
    convention: DimensionToAxisConvention = .widthIsHorizontal
  ) -> CGFloat {
    switch self {
      case .horizontal:
        return convention.horizontalLength(rect: rect)
      case .vertical:
        return convention.verticalLength(rect: rect)
    }
  }
  
  /// Returns the sum of the two *opposing* inset lengths, for this axis,
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

  /// Returns the coordinate for this axis from a `CGPoint`,
  /// interpreting x/y according to the given convention.
  //  public func length(
  //    from point: CGPoint,
  //    convention: DimensionToAxisConvention = .widthIsHorizontal
  //  ) -> CGFloat {
  //    switch self {
  //      case .horizontal:
  //        return convention.horizontalLength(point: point)
  //      case .vertical:
  //        return convention.verticalLength(point: point)
  //    }
  //  }



  /// Returns the total inset length for this axis from `UnitPoint`,
  /// interpreting x/y according to the given convention.
  //  public func length(
  //    from unitPoint: UnitPoint,
  //    convention: DimensionToAxisConvention = .widthIsHorizontal
  //  ) -> CGFloat {
  //    switch self {
  //      case .horizontal:
  //        return convention.horizontalLength(unitPoint: unitPoint)
  //      case .vertical:
  //        return convention.verticalLength(unitPoint: unitPoint)
  //    }
  //  }

}
