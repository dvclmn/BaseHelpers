//
//  Model+BoundaryPoint.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 6/8/2025.
//

import SwiftUI

public enum GridBoundaryPoint {

  /// Row edges
  case top
  case bottom

  /// Column edges
  case leading
  case trailing

  /// Corners
  case topLeading
  case bottomLeading
  case topTrailing
  case bottomTrailing
}

extension GridBoundaryPoint {

  public init(fromEdge edge: GridEdge) {
    self =
      switch edge {
        case .top: .top
        case .trailing: .trailing
        case .bottom: .bottom
        case .leading: .leading
      }
  }

  public var isRowEdge: Bool {
    self == .top || self == .bottom
  }

  public var isColumnEdge: Bool {
    self == .leading || self == .trailing
  }

  public var isCorner: Bool {
    self == .topLeading
      || self == .topTrailing
      || self == .bottomLeading
      || self == .bottomTrailing
  }

  public var gridAxis: GridAxis? {
    if isRowEdge {
      .rows
    } else if isColumnEdge {
      .columns
    } else {
      nil
    }
  }

  public var gridEdge: GridEdge? {
    switch self {
      case .top: .top
      case .bottom: .bottom
      case .leading: .leading
      case .trailing: .trailing
      default: nil
    }
  }

}

extension UnitPoint {
  public var gridBoundaryPoint: GridBoundaryPoint {
    switch self {
      case .topLeading: .topLeading
      case .top: .top
      case .topTrailing: .topTrailing
      case .trailing: .trailing
      case .bottomTrailing: .bottomTrailing
      case .bottom: .bottom
      case .bottomLeading: .bottomLeading
      case .leading: .leading

      default:
        fatalError("Unsupoorted unit point: \(self), for conversion to GridBoundaryPoint.")
    }
  }
}
