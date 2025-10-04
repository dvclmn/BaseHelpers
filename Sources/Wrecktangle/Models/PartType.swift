//
//  PartType.swift
//  BoxCore
//
//  Created by Dave Coleman on 13/9/2024.
//

import SwiftUICore
import BaseHelpers

public extension BoxCore {
  
  enum HorizontalLocation: Hashable {
    case top
    case bottom
    case interior // Divider
  }
  
  enum VerticalLocation: Hashable, Sendable {
    case leading
    case trailing
    case interior // Divider
  }

  enum PartType: Hashable {
    
    case horizontal(BoxCore.HorizontalLocation = .top)
    case vertical(BoxCore.VerticalLocation = .leading)
    case join(JoinType)
    case corner(CornerType)
    
    
    public var flexibility: PartFlexibility {
      switch self {
        case .horizontal:
            .repeatable(axis: .horizontal)
          
        case .vertical:
            .repeatable(axis: .vertical)
          
        default:
            .fixed
      }
    }
  } // END part type
  
  enum LineSegment {
    case capLeading
    case capTrailing
  }
  
  enum PartFlexibility: Equatable {
    case repeatable(axis: Axis)
    case fixed
  }
  
  
}
