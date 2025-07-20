//
//  Model+GridPosition.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/7/2025.
//

import Foundation

/// Represents a position in a 2D Grid (rows and columns)
public struct GridPosition: GridBase {
  public let column: Int
  public let row: Int

  public init(
    column: Int,
    row: Int,
  ) {
    precondition(row >= 0 && column >= 0, "GridPosition cannot be negative.")
    self.column = column
    self.row = row
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
    /// Going to let the main init's precondition catch this
//    guard point.hasValidValue, cellSize.hasValidValue else { return nil }
    let row = Int(floor(point.y / cellSize.height))
    let col = Int(floor(point.x / cellSize.width))

    self.init(column: col, row: row)
  }
}

extension GridPosition {

  /// Note: zero-based count for internal representation,
  /// one-based for UI
  public static var zero: GridPosition {
    GridPosition(column: 0, row: 0)
  }

  var displayRow: Int { row + 1 }
  var displayColumn: Int { column + 1 }

  public var displayString: String {
    "Row \(displayRow), Column \(displayColumn)"
  }

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
    let delta = edge.directionVector
    return GridPosition(
      column: max(0, column + delta.column),
      row: max(0, row + delta.row)
    )
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

}

public func + (lhs: GridPosition, rhs: GridPosition) -> GridPosition {
  return GridPosition(
    column: lhs.column + rhs.column, row: lhs.row + rhs.row
  )
}

extension GridPosition: CustomStringConvertible {
  public var description: String {
    """
    GridPosition[X: \(column), Y: \(row)]
    """
  }
}
