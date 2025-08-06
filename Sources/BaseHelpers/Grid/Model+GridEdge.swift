//
//  Model+GridEdge.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/7/2025.
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

//public enum GridEdge: GridBase {
//  case top
//  case trailing
//  case bottom
//  case leading

//  public var isRowEdge: Bool {
//    self == .top || self == .bottom
//  }
//
//  public var isColumnEdge: Bool {
//    self == .leading || self == .trailing
//  }
//}

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

extension GridBoundaryPoint {

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
  //
  //  var gridPositionKeyPath: KeyPath<GridPosition, Int>? {
  //    switch toUnitPoint.pointType {
  //      case .horizontalEdge: \.row
  //      case .verticalEdge: \.column
  //      case .corner, .centre: nil
  //    }
  //  }

  //  var isColumnPoint: Bool {
  //    switch toUnitPoint.pointType {
  //      case .verticalEdge: true
  //      default: false
  //    }
  //  }
  //
  //  var isRowPoint: Bool {
  //    switch toUnitPoint.pointType {
  //      case .horizontalEdge: true
  //      default: false
  //    }
  //  }
  //
  //  var gridAxis: GridAxis? {
  //    switch toUnitPoint.pointType {
  //      case .verticalEdge: .columns
  //      case .horizontalEdge: .rows
  //      default: nil
  //    }
  //  }

  //  var gridEdge: GridEdge? {
  //    switch self {
  //      case .top: .top
  //      case .trailing: .trailing
  //      case .leading: .leading
  //      case .bottom: .bottom
  //
  //      default: nil
  //    }
  //    //    switch toUnitPoint.pointType {
  //    //      case .verticalEdge: .
  //    //      case .horizontalEdge: .rows
  //    //      default: nil
  //    //    }
  //  }
}
