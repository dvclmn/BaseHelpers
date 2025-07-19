//
//  Model+GridPosition.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/7/2025.
//

import SwiftUI

/// Represents a position in a 2D Grid (rows and columns)
public struct GridPosition: GridBase {
  public let column: Int
  public let row: Int

  public init(
    column: Int,
    row: Int,
  ) {
    precondition(column > 0 && row > 0, "GridPosition cannot be initialised at 0,0")
//    guard column > 0, row > 0 else { fatalError("") }
    self.column = column - 1
    self.row = row - 1
  }

  /// `cellSize` is the width and height in points
  /// of a single cell in the current `GridCanvas`.
  /// It is not affected by zoom, it operates in local
  /// Canvas Space
  ///
  /// `point` must already be mapped to local Canvas space
  public init?(
    point: CGPoint,
    cellSize: CGSize
  ) {
    guard point.hasValidValue, cellSize.hasValidValue else { return nil }
    let row = Int(floor(point.y / cellSize.height))
    let col = Int(floor(point.x / cellSize.width))

//    guard row > 0, col > 0 else { return nil }
    
    self.init(column: max(1, col), row: max(1, row))
  }
}

extension GridPosition {
  
  public var isGreaterThanZero: Bool {
    return column > 0 && row > 0
  }

  /// Converts grid position to canvas-space point
  /// - Parameter cellSize: The size of each grid cell
  /// - Returns: The top-left point of the cell in canvas coordinates
  public func toCGPoint(cellSize: CGSize) -> CGPoint {
    CGPoint(
      x: CGFloat(column) * cellSize.width,
      y: CGFloat(row) * cellSize.height
    )
  }

  public func neighbour(at edge: CellEdge) -> GridPosition {
    switch edge {
      case .top: return GridPosition(column: column, row: row - 1)
      case .bottom: return GridPosition(column: column, row: row + 1)
      case .left: return GridPosition(column: column - 1, row: row)
      case .right: return GridPosition(column: column + 1, row: row)
    }
  }

  public func toCGRect(cellSize: CGSize) -> CGRect {
    CGRect(
      x: CGFloat(column) * cellSize.width,
      y: CGFloat(row) * cellSize.height,
      width: cellSize.width,
      height: cellSize.height
    )
  }

  public func toIndex(columns: Int) -> Int {
    row * columns + column
  }


  public static var origin: GridPosition {
    GridPosition(column: 1, row: 1)
  }
  /// Basic offset methods
  public func offsetBy(row deltaRow: Int, col deltaCol: Int) -> GridPosition {
    GridPosition(column: column + deltaCol, row: row + deltaRow)
  }

  public mutating func offsetting(by delta: GridPosition) {
    let current = self
    self = current + delta
  }

  public mutating func offsetting(_ direction: Direction, by delta: Int = 1) {
    let (newCol, newRow) = direction.offset(x: column, y: row, by: delta)
    self = GridPosition(column: newCol, row: newRow)
  }

  public func isValidWithin(grid: GridDimensions) -> Bool {
    return grid.contains(self)
  }

}

public func + (lhs: GridPosition, rhs: GridPosition) -> GridPosition {
  return GridPosition(
    column: lhs.column + rhs.column, row: lhs.row + rhs.row
  )
}

extension Collection where Element == GridPosition {

  /// This version of `toCGRect` skips needing to create intermediate
  /// `GridRect`, instead just creating one at the end.
  public func toCGRect(cellSize: CGSize) -> CGRect {
    guard let first = self.first else { return .null }

    var minRow = first.row
    var maxRow = first.row
    var minCol = first.column
    var maxCol = first.column

    for position in self.dropFirst() {
      minRow = Swift.min(minRow, position.row)
      maxRow = Swift.max(maxRow, position.row)
      minCol = Swift.min(minCol, position.column)
      maxCol = Swift.max(maxCol, position.column)
    }

    let origin = GridPosition(column: minCol, row: minRow)
    let size = GridDimensions(
      columns: maxCol - minCol + 1,
      rows: maxRow - minRow + 1
    )

    let gridRect = GridRect(origin: origin, size: size)
    return gridRect.toCGRect(cellSize: cellSize)
  }
}

extension GridPosition: CustomStringConvertible {
  public var description: String {
    """
    GridPosition[X: \(column), Y: \(row)]
    """
  }
}

public enum CellEdge: CaseIterable {
  case top, bottom, left, right

  public func path(in rect: CGRect) -> Path {
    switch self {
      case .top:
        return Path {
          $0.move(to: rect.minXminY)
          $0.addLine(to: rect.maxXminY)
        }
      case .bottom:
        return Path {
          $0.move(to: rect.minXmaxY)
          $0.addLine(to: rect.maxXmaxY)
        }
      case .left:
        return Path {
          $0.move(to: rect.minXminY)
          $0.addLine(to: rect.minXmaxY)
        }
      case .right:
        return Path {
          $0.move(to: rect.maxXminY)
          $0.addLine(to: rect.maxXmaxY)
        }
    }
  }
}

extension GridPosition {
  
  public func moved(
    in direction: Direction,
    by delta: Int = 1,
    gridDimensions: GridDimensions
  ) -> GridPosition {
    let offset = direction.offset(x: column, y: row, by: delta)
    return GridPosition(column: offset.x, row: offset.y)
      .wrapped(columns: gridDimensions.columns, rows: gridDimensions.rows)
  }
  
  public func wrapped(columns: Int, rows: Int) -> GridPosition {
    let wrappedCol = ((column - 1) % columns + columns) % columns + 1
    let wrappedRow = ((row - 1) % rows + rows) % rows + 1
    return GridPosition(column: wrappedCol, row: wrappedRow)
  }
  
//  public func wrapped(
//    gridDimensions: GridDimensions
////    columns: Int,
////    rows: Int
//  ) -> GridPosition {
//    let columns = gridDimensions.columns
//    let rows = gridDimensions.rows
//    
//    let wrappedCol = ((column - 1) % columns + columns) % columns + 1
//    let wrappedRow = ((row - 1) % rows + rows) % rows + 1
//    return GridPosition(column: wrappedCol, row: wrappedRow)
//  }
//  
//  private func movedLeft(columns: Int) -> GridPosition {
//    GridPosition(column: column - 1, row: row)
//      .wrapped(columns: columns, rows: 1)
//  }
//  
//  private func movedRight(columns: Int) -> GridPosition {
//    GridPosition(column: column + 1, row: row)
//      .wrapped(columns: columns, rows: 1)
//  }
//  
//  private func movedUp(rows: Int) -> GridPosition {
//    GridPosition(column: column, row: row - 1)
//      .wrapped(columns: 1, rows: rows)
//  }
//  
//  private func movedDown(rows: Int) -> GridPosition {
//    GridPosition(column: column, row: row + 1)
//      .wrapped(columns: 1, rows: rows)
//  }
//  
//  public func movedBy(
//    deltaCol: Int,
//    deltaRow: Int,
//    gridDimensions: GridDimensions
////    columns: Int,
////    rows: Int
//  ) -> GridPosition {
//    GridPosition(column: column + deltaCol, row: row + deltaRow)
//      .wrapped(columns: gridDimensions.columns, rows: gridDimensions.rows)
//  }
  
}
