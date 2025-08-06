//
//  Model+GridEdge.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/7/2025.
//

import SwiftUI

public enum GridEdge: GridBase {
  case top
  case trailing
  case bottom
  case leading

  public init?(fromBoundaryPoint point: GridBoundaryPoint) {
    guard let edge = point.gridEdge else { return nil }
    self = edge
  }

  public var gridBoundaryPoint: GridBoundaryPoint {
    let point = GridBoundaryPoint(fromEdge: self)
    return point
  }
  
}
