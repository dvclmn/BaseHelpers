//
//  Axis.swift
//  Collection
//
//  Created by Dave Coleman on 30/10/2024.
//

import SwiftUI

/// Explicit convention
/// ```
/// Axis.horizontal.length(
///   from: size,
///   convention: .widthIsHorizontal
/// )
/// ```
public enum DimensionToAxisConvention {
  case widthIsHorizontal
  case heightIsHorizontal

  // MARK: - EdgeInsets Helpers
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
    horizontalLengthStart(edgeInsets)
      + horizontalLengthEnd(edgeInsets)
  }
  public func verticalLength(edgeInsets: EdgeInsets) -> CGFloat {
    verticalLengthStart(edgeInsets)
      + verticalLengthEnd(edgeInsets)
  }


  // MARK: - CGSize
  public func horizontalLength(size: CGSize) -> CGFloat {
    switch self {
      case .widthIsHorizontal:
        return size.width
      case .heightIsHorizontal:
        return size.height
    }
  }

  public func verticalLength(size: CGSize) -> CGFloat {
    switch self {
      case .widthIsHorizontal:
        return size.height
      case .heightIsHorizontal:
        return size.width
    }
  }

  // MARK: - CGPoint
  public func horizontalLength(point: CGPoint) -> CGFloat {
    switch self {
      case .widthIsHorizontal:
        return point.x
      case .heightIsHorizontal:
        return point.y
    }
  }

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

    //    let rawValue = self.rawValue
    //    return Axis.Set(rawValue: rawValue)
  }

  public var name: String {
    switch self {
      case .horizontal:
        "X"
      case .vertical:
        "Y"
    }
  }


  public func length(
    size: CGSize,
    convention: DimensionToAxisConvention = .widthIsHorizontal
  ) -> CGFloat {
    switch (self, convention) {
      case (.horizontal, .widthIsHorizontal), (.vertical, .heightIsHorizontal):
        return convention.horizontalLength(size: size)
      case (.horizontal, .heightIsHorizontal), (.vertical, .widthIsHorizontal):
        return convention.verticalLength(size: size)
    }
  }

  public func length(
    edgeInsets: EdgeInsets,
    convention: DimensionToAxisConvention = .widthIsHorizontal
  ) -> CGFloat {
    switch (self, convention) {
      case (.horizontal, .widthIsHorizontal), (.vertical, .heightIsHorizontal):
        return convention.horizontalLength(edgeInsets: edgeInsets)
      case (.horizontal, .heightIsHorizontal), (.vertical, .widthIsHorizontal):
        return convention.verticalLength(edgeInsets: edgeInsets)
    }
  }

  public func length(
    point: CGPoint,
    convention: DimensionToAxisConvention = .widthIsHorizontal
  ) -> CGFloat {
    switch (self, convention) {
      case (.horizontal, .widthIsHorizontal), (.vertical, .heightIsHorizontal):
        return convention.horizontalLength(point: point)
      case (.horizontal, .heightIsHorizontal), (.vertical, .widthIsHorizontal):
        return convention.verticalLength(point: point)
    }
  }

  public func length(
    unitPoint: UnitPoint,
    convention: DimensionToAxisConvention = .widthIsHorizontal
  ) -> CGFloat {
    switch (self, convention) {
      case (.horizontal, .widthIsHorizontal), (.vertical, .heightIsHorizontal):
        return convention.horizontalLength(unitPoint: unitPoint)
      case (.horizontal, .heightIsHorizontal), (.vertical, .widthIsHorizontal):
        return convention.verticalLength(unitPoint: unitPoint)
    }
  }

  public func dimension(
    from rect: CGRect,
    convention: DimensionToAxisConvention = .widthIsHorizontal
  ) -> CGFloat {
    
    switch (self, convention) {
      case (.horizontal, .widthIsHorizontal), (.vertical, .widthIsHorizontal):
        return rect.width
      case (.horizontal, .heightIsHorizontal), (.vertical, .heightIsHorizontal):
        return rect.height
    }
//    switch self {
//      case .horizontal:
//        return rect.width
//      case .vertical:
//        return rect.height
//    }
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
