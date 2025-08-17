//
//  Model+CellEdge.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 20/7/2025.
//

import SwiftUI

extension Edge {
  /// The coordinate delta for moving in this direction
  public var directionVector: (column: Int, row: Int) {
    switch self {
      case .top: return (column: 0, row: -1)
      case .bottom: return (column: 0, row: 1)
      case .leading: return (column: -1, row: 0)
      case .trailing: return (column: 1, row: 0)
    }
  }
  
  public func path(in rect: CGRect) -> Path {
    let (start, end) = rect.edgePoints(for: self)
    return Path {
      $0.move(to: start)
      $0.addLine(to: end)
    }
  }
  
}
