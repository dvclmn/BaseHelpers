//
//  Axis.swift
//  Collection
//
//  Created by Dave Coleman on 30/10/2024.
//

import SwiftUI

//extension Axis.Set {
//  public var toAxis: Axis {
//
//  }
//}
//public protocol MappableToAxis {
//  func keyPath(_ mapping: DimensionToAxisMapping) -> KeyPath<Self, CGFloat>
//}
//extension EdgeInsets: MappableToAxis {
//  public func keyPath(_ mapping: DimensionToAxisMapping) -> KeyPath<Self, CGFloat> {
//    switch mapping {
//      case .widthIsHorizontal:
//        return \.leading
//      case .heightIsHorizontal:
//        return \.top
//    }
//  }
//}

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
  
  public var keyPathCGSize: KeyPath<CGSize, CGFloat> {
    switch self {
      case .widthIsHorizontal:
        return \.width
      case .heightIsHorizontal:
        return \.height
    }
  }
  public var keyPathEdgeInsetsStart: KeyPath<EdgeInsets, CGFloat> {
    switch self {
      case .widthIsHorizontal:
        return \.leading
      case .heightIsHorizontal:
        return \.top
    }
  }
  public var keyPathEdgeInsetsEnd: KeyPath<EdgeInsets, CGFloat> {
    switch self {
      case .widthIsHorizontal:
        return \.trailing
      case .heightIsHorizontal:
        return \.bottom
    }
  }
  public var keyPathCGPoint: KeyPath<CGPoint, CGFloat> {
    switch self {
      case .widthIsHorizontal:
        return \.x
      case .heightIsHorizontal:
        return \.y
    }
  }
  
  public func length(_ edgeInsets: EdgeInsets) -> CGFloat {
    switch self {
      case .widthIsHorizontal:
        return edgeInsets.top + edgeInsets.bottom
      case .heightIsHorizontal:
        return edgeInsets.leading + edgeInsets.trailing
    }
  }
  
  //    public func horizontalLength(_ size: CGSize) -> CGFloat {
  //      switch self {
  //        case .widthIsHorizontal:
  //          return size.width
  //        case .heightIsHorizontal:
  //          return size.height
  //      }
  //    }
  //
  //    public func verticalLength(_ size: CGSize) -> CGFloat {
  //      switch self {
  //        case .widthIsHorizontal:
  //          return size.height
  //        case .heightIsHorizontal:
  //          return size.width
  //      }
  //    }
  //
  //    public func horizontalLength(_ edgeInsets: EdgeInsets) -> CGFloat {
  //      switch self {
  //        case .widthIsHorizontal:
  //          return edgeInsets.leading + edgeInsets.trailing
  //        case .heightIsHorizontal:
  //          return edgeInsets.top + edgeInsets.bottom
  //      }
  //    }
  //
  //    public func verticalLength(_ edgeInsets: EdgeInsets) -> CGFloat {
  //      switch self {
  //        case .widthIsHorizontal:
  //          return edgeInsets.top + edgeInsets.bottom
  //        case .heightIsHorizontal:
  //          return edgeInsets.leading + edgeInsets.trailing
  //      }
  //    }
  //
  
  // Convenience initializer from Axis with explicit convention
  //    public init(axis: Axis, convention: AxisConvention) {
  //      switch (axis, convention) {
  //        case (.horizontal, .standard), (.vertical, .inverted):
  //          self = .widthIsHorizontal
  //        case (.horizontal, .inverted), (.vertical, .standard):
  //          self = .heightIsHorizontal
  //      }
  //    }
  
  //    public enum AxisConvention {
  //      case standard  // horizontal maps to width, vertical maps to height
  //      case inverted  // horizontal maps to height, vertical maps to width
  //    }
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
    from size: CGSize,
    mapping: DimensionToAxisMapping = .widthIsHorizontal
  ) -> CGFloat {
    switch (self, mapping) {
      case (.horizontal, .widthIsHorizontal), (.vertical, .heightIsHorizontal):
        return mapping.horizontalLength(size)
      case (.horizontal, .heightIsHorizontal), (.vertical, .widthIsHorizontal):
        return mapping.verticalLength(size)
    }
  }
  
  public func length(
    from edgeInsets: EdgeInsets,
    mapping: DimensionToAxisMapping = .widthIsHorizontal
  ) -> CGFloat {
    switch (self, mapping) {
      case (.horizontal, .widthIsHorizontal), (.vertical, .heightIsHorizontal):
        return mapping.horizontalLength(edgeInsets)
      case (.horizontal, .heightIsHorizontal), (.vertical, .widthIsHorizontal):
        return mapping.verticalLength(edgeInsets)
    }
  }
  
//  public func length(
//    from edgeInsets: EdgeInsets,
//    mapping: DimensionToAxisMapping = .widthIsHorizontal
//  ) -> CGFloat {
//    switch (self, mapping) {
//      case (.horizontal, .widthIsHorizontal), (.vertical, .heightIsHorizontal):
//        return mapping.horizontalLength(size)
//      case (.horizontal, .heightIsHorizontal), (.vertical, .widthIsHorizontal):
//        return mapping.verticalLength(size)
//    }
//  }

  // Even more ergonomic: direct convention-based method
//  public func length(
//    from size: CGSize,
//    convention: DimensionToAxisMapping.AxisConvention = .standard
//  ) -> CGFloat {
//    let mapping = DimensionToAxisMapping(axis: self, convention: convention)
//    return length(from: size, mapping: mapping)
//  }


  //  public func perpendicularDimension(from size: CGSize) -> CGFloat {
  //    switch self {
  //      case .horizontal:
  //        return size.width
  //      case .vertical:
  //        return size.height
  //    }
  //  }

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
