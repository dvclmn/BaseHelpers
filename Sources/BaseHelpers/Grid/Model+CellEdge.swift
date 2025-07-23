//
//  Model+CellEdge.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 20/7/2025.
//

import SwiftUI

public enum RectEdge: CaseIterable {
  case top, bottom, left, right
  
  /// The coordinate delta for moving in this direction
  public var directionVector: (column: Int, row: Int) {
    switch self {
      case .top: return (column: 0, row: -1)
      case .bottom: return (column: 0, row: 1)
      case .left: return (column: -1, row: 0)
      case .right: return (column: 1, row: 0)
    }
  }
  
  public func path(in rect: CGRect) -> Path {
    let (start, end) = rect.edgePoints(for: self)
    return Path {
      $0.move(to: start)
      $0.addLine(to: end)
    }
  }
  
//  public func path(in rect: CGRect) -> Path {
//    switch self {
//      case .top:
//        return Path {
//          $0.move(to: rect.minXminY)
//          $0.addLine(to: rect.maxXminY)
//        }
//      case .bottom:
//        return Path {
//          $0.move(to: rect.minXmaxY)
//          $0.addLine(to: rect.maxXmaxY)
//        }
//      case .left:
//        return Path {
//          $0.move(to: rect.minXminY)
//          $0.addLine(to: rect.minXmaxY)
//        }
//      case .right:
//        return Path {
//          $0.move(to: rect.maxXminY)
//          $0.addLine(to: rect.maxXmaxY)
//        }
//    }
//  }
}
