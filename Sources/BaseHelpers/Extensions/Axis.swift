//
//  Axis.swift
//  Collection
//
//  Created by Dave Coleman on 30/10/2024.
//

import SwiftUI



extension Axis {

  public enum DimensionToAxisMapping {
    case widthIsHorizontal
    case heightIsHorizontal
    
    public func horizontalLength(_ size: CGSize) -> CGFloat {
      switch self {
        case .widthIsHorizontal:
          return size.width
          
        case .heightIsHorizontal:
          return size.height
      }
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

  
  public func length(
    from size: CGSize,
    mapping: DimensionToAxisMapping = .widthIsHorizontal
//    isPerpendicular: Bool = false
  ) -> CGFloat {
    
    
    switch self {
      case .horizontal:
        return isPerpendicular ? size.height : size.width
      case .vertical:
        return isPerpendicular ? size.width : size.height
    }
  }

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
