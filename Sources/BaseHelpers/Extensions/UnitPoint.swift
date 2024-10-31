//
//  UnitPoint.swift
//  Collection
//
//  Created by Dave Coleman on 30/10/2024.
//

import SwiftUI
import Foundation

public extension UnitPoint {
  
  var toAlignment: Alignment {
    
    switch self {
        
      case .topLeading: return .topLeading
      case .top: return .top
      case .topTrailing: return .topTrailing
        
      case .trailing: return .trailing
        
      case .bottomTrailing: return .bottomTrailing
      case .bottom: return .bottom
      case .bottomLeading: return .bottomLeading
        
      case .leading: return .leading

      case .center: return .center
      
      default: return .center
    }
  }
  
  var name: String {
    switch self {
      case .topLeading: "Top Leading"
      case .top: "Top"
      case .topTrailing: "Top Trailing"
      case .trailing: "Trailing"
      case .bottomTrailing: "Bottom Trailing"
      case .bottom: "Bottom"
      case .bottomLeading: "Bottom Leading"
      case .leading: "Leading"
      case .center: "Center"
      default:
        "Unknown"
    }
  }
}
