//
//  Edge.swift
//  Collection
//
//  Created by Dave Coleman on 20/12/2024.
//

import SwiftUI

public extension Edge {
  
  static let zero: Double = 0.00
  static let quarter: Double = 0.25
  static let halfway: Double = 0.5
  static let full: Double = 1.0
  
  var off: UnitPoint {
    switch self {
      case .top:
        UnitPoint(x: Edge.halfway, y: Edge.zero)
      case .leading:
        UnitPoint(x: Edge.zero, y: Edge.halfway)
      case .bottom:
        UnitPoint(x: Edge.halfway, y: Edge.full)
      case .trailing:
        UnitPoint(x: Edge.full, y: Edge.halfway)
    }
  }
  
  var on: UnitPoint {
    UnitPoint.halfway
  }
  
  var onQuarter: UnitPoint {
    switch self {
      case .top:
        UnitPoint(x: Edge.halfway, y: Edge.quarter)
      case .leading:
        UnitPoint(x: Edge.quarter, y: Edge.halfway)
      case .bottom:
        UnitPoint(x: Edge.halfway, y: Edge.quarter)
      case .trailing:
        UnitPoint(x: Edge.quarter, y: Edge.halfway)
    }
  }
  
  
  var name: String {
    switch self {
      case .top: "Top"
      case .leading: "Leading"
      case .bottom: "Bottom"
      case .trailing: "Trailing"
    }
  }
  
  var axis: Axis {
    switch self {
      case .top, .bottom: .vertical
      case .leading, .trailing: .horizontal
    }
  }
  var alignment: Alignment {
    switch self {
      case .top: .top
      case .bottom: .bottom
      case .leading: .leading
      case .trailing: .trailing
        
    }
  }
  var edgeSet: Edge.Set {
    switch self {
      case .top: .top
      case .leading: .leading
      case .bottom: .bottom
      case .trailing: .trailing
    }
  }

  
  var alignmentOpposite: Alignment {
    switch self {
      case .top: .bottom
      case .bottom: .top
      case .leading: .trailing
      case .trailing: .leading
    }
  }

  
}
