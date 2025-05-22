//
//  Axis.swift
//  Collection
//
//  Created by Dave Coleman on 30/10/2024.
//

import SwiftUI

/// Explicit mapping
/// ```
/// Axis.horizontal.length(
///   from: size,
///   mapping: .widthIsHorizontal
/// )
/// ```
public enum DimensionToAxisMapping {
  case widthIsHorizontal
  case heightIsHorizontal

  //  public var keyPathCGSize: KeyPath<CGSize, CGFloat> {
  //    switch self {
  //      case .widthIsHorizontal:
  //        return \.width
  //      case .heightIsHorizontal:
  //        return \.height
  //    }
  //  }
  //
  //  public var keyPathCGPoint: KeyPath<CGPoint, CGFloat> {
  //    switch self {
  //      case .widthIsHorizontal:
  //        return \.x
  //      case .heightIsHorizontal:
  //        return \.y
  //    }
  //  }


  // MARK: - EdgeInsets

  public func horizontalLengthStart(_ edgeInsets: EdgeInsets) -> CGFloat {
    switch self {
      case .widthIsHorizontal:
        return edgeInsets.top
      case .heightIsHorizontal:
        return edgeInsets.leading
    }
  }
  public func horizontalLengthEnd(_ edgeInsets: EdgeInsets) -> CGFloat {
    switch self {
      case .widthIsHorizontal:
        return edgeInsets.bottom
      case .heightIsHorizontal:
        return edgeInsets.trailing
    }
  }

  public func verticalLengthStart(_ edgeInsets: EdgeInsets) -> CGFloat {
    switch self {
      case .widthIsHorizontal:
        return edgeInsets.leading
      case .heightIsHorizontal:
        return edgeInsets.top
    }
  }
  public func verticalLengthEnd(_ edgeInsets: EdgeInsets) -> CGFloat {
    switch self {
      case .widthIsHorizontal:
        return edgeInsets.trailing
      case .heightIsHorizontal:
        return edgeInsets.bottom
    }
  }

  // MARK: Final EdgeInsets
  public func horizontalLength(edgeInsets: EdgeInsets) -> CGFloat {

    horizontalLengthStart(edgeInsets)
      + horizontalLengthEnd(edgeInsets)
  }
  public func verticalLength(edgeInsets: EdgeInsets) -> CGFloat {
    verticalLengthStart(edgeInsets)
      + verticalLengthEnd(edgeInsets)
  }


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
}

extension Axis {


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
    mapping: DimensionToAxisMapping = .widthIsHorizontal
  ) -> CGFloat {
    switch (self, mapping) {
      case (.horizontal, .widthIsHorizontal), (.vertical, .heightIsHorizontal):
        return mapping.horizontalLength(size: size)
      case (.horizontal, .heightIsHorizontal), (.vertical, .widthIsHorizontal):
        return mapping.verticalLength(size: size)
    }
  }

  public func length(
    edgeInsets: EdgeInsets,
    mapping: DimensionToAxisMapping = .widthIsHorizontal
  ) -> CGFloat {
    switch (self, mapping) {
      case (.horizontal, .widthIsHorizontal), (.vertical, .heightIsHorizontal):
        return mapping.horizontalLength(edgeInsets: edgeInsets)
      case (.horizontal, .heightIsHorizontal), (.vertical, .widthIsHorizontal):
        return mapping.verticalLength(edgeInsets: edgeInsets)
    }
  }

  public func length(
    point: CGPoint,
    mapping: DimensionToAxisMapping = .widthIsHorizontal
  ) -> CGFloat {
    switch (self, mapping) {
      case (.horizontal, .widthIsHorizontal), (.vertical, .heightIsHorizontal):
        return mapping.horizontalLength(point: point)
      case (.horizontal, .heightIsHorizontal), (.vertical, .widthIsHorizontal):
        return mapping.verticalLength(point: point)
    }
  }

  public func dimension(from rect: CGRect) -> CGFloat {
    switch self {
      case .horizontal:
        return rect.width
      case .vertical:
        return rect.height
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
