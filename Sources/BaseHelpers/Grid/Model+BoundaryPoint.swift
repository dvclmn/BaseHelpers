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
  
  public init(fromResizePoint point: ResizePoint) {
    self = switch point {
      case .topLeading: .topLeading
      case .topTrailing: .topTrailing
      case .bottomLeading: .bottomLeading
      case .bottomTrailing: .bottomTrailing
      case .top: .top
      case .trailing: .trailing
      case .leading: .leading
      case .bottom: .bottom
    }
  }

  //  public func sizeDelta(
  //    startSize: CGSize,
  //    newSize: CGSize,
  //    cellSize: CGSize
  //  ) {
  //    let sizeDelta: CGSize = newSize - startSize
  //  }

  /// Checks whether a size delta is valid for the control point.
  /// i.e. the opposite axis should not change.
  public func isValidSizeDelta(
    from oldSize: CGSize,
    to newSize: CGSize
  ) -> Bool {
    switch self {
      case .top, .bottom:
        return oldSize.width == newSize.width
      case .leading, .trailing:
        return oldSize.height == newSize.height
      case .topLeading, .bottomLeading, .topTrailing, .bottomTrailing:
        /// Both axes are allowed to change at corners
        return true
    }
  }

  public func sizeDelta(
    columnDelta: Int,
    rowDelta: Int,
  ) -> GridDimensions {
    switch self {
      case .top:
        return GridDimensions(
          columns: 0,
          rows: -rowDelta
        )
      case .bottom:
        return GridDimensions(
          columns: 0,
          rows: rowDelta
        )
      case .leading:
        return GridDimensions(
          columns: -columnDelta,
          rows: 0
        )
      case .trailing:
        return GridDimensions(
          columns: columnDelta,
          rows: 0
        )
      case .topLeading:
        return GridDimensions(
          columns: -columnDelta,
          rows: -rowDelta
        )
      case .bottomLeading:
        return GridDimensions(
          columns: -columnDelta,
          rows: rowDelta
        )
      case .topTrailing:
        return GridDimensions(
          columns: columnDelta,
          rows: -rowDelta
        )
      case .bottomTrailing:
        return GridDimensions(
          columns: columnDelta,
          rows: rowDelta
        )
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
      .row
    } else if isColumnEdge {
      .column
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

  public var affectedEdges: GridEdge.Set {
    switch self {
      case .top: return [.top]
      case .bottom: return [.bottom]
      case .leading: return [.leading]
      case .trailing: return [.trailing]
      case .topLeading: return [.top, .leading]
      case .topTrailing: return [.top, .trailing]
      case .bottomLeading: return [.bottom, .leading]
      case .bottomTrailing: return [.bottom, .trailing]
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
