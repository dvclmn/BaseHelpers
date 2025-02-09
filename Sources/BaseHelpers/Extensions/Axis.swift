//
//  Axis.swift
//  Collection
//
//  Created by Dave Coleman on 30/10/2024.
//

import SwiftUI

extension Axis {
  /// Returns either the width or height of a CGSize based on the axis.
  /// - Parameter size: The CGSize to extract the dimension from
  /// - Returns: The appropriate dimension (width for vertical, height for horizontal)
#warning("DragToSelect wants this to be horizontal == width, vertical == height. Other domains may have different requirements, which needs to be addressed")
  public func dimension(from size: CGSize) -> CGFloat {
    switch self {
      case .horizontal:
        return size.width
      case .vertical:
        return size.height
    }
  }

  /// Returns either the width or height of a CGSize based on the perpendicular axis.
  /// - Parameter size: The CGSize to extract the dimension from
  /// - Returns: The perpendicular dimension (width for horizontal, height for vertical)
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
}

extension Axis {
  
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
