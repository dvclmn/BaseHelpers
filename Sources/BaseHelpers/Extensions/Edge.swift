//
//  Edge.swift
//  Collection
//
//  Created by Dave Coleman on 20/12/2024.
//

import SwiftUI

extension Edge {

  public static let zero: Double = 0.00
  public static let quarter: Double = 0.25
  public static let halfway: Double = 0.5
  public static let full: Double = 1.0

  public var off: UnitPoint {
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

  public var on: UnitPoint {
    UnitPoint(x: Edge.halfway, y: Edge.halfway)
  }

  public var onQuarter: UnitPoint {
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


  public var name: String {
    switch self {
      case .top: "Top"
      case .leading: "Leading"
      case .bottom: "Bottom"
      case .trailing: "Trailing"
    }
  }

  public var axis: Axis {
    switch self {
      case .top, .bottom: .vertical
      case .leading, .trailing: .horizontal
    }
  }

  public var alignment: Alignment {
    switch self {
      case .top: .top
      case .bottom: .bottom
      case .leading: .leading
      case .trailing: .trailing

    }
  }
  public var edgeSet: Edge.Set {
    switch self {
      case .top: .top
      case .leading: .leading
      case .bottom: .bottom
      case .trailing: .trailing
    }
  }


  public var alignmentOpposite: Alignment {
    switch self {
      case .top: .bottom
      case .bottom: .top
      case .leading: .trailing
      case .trailing: .leading
    }
  }
}
