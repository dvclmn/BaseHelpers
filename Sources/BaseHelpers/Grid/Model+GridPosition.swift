//
//  Model+GridPosition.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/7/2025.
//

import SwiftUI

/// Represents a position in a 2D Grid (rows and columns).
public struct GridPosition: GridBase {
  public let column: Int
  public let row: Int

  public init(
    column: Int,
    row: Int,
  ) {
    precondition(row >= 0 && column >= 0, "GridPosition cannot be negative, in either dimension.")
    self.column = column
    self.row = row
  }

  /// `cellSize` is the width and height in points
  /// of a single cell in the current `GridCanvas`.
  /// It is not affected by zoom, it operates in local
  /// Canvas Space
  ///
  /// `point` must already be mapped to local Canvas space
  public init(
    point: CGPoint,
    cellSize: CGSize
  ) {
    /// `floor()` here maps a continuous coordinate to the
    /// nearest lower integer, effectively identifying which grid cell
    /// the point belongs to.
    let col = Int(floor(point.x / cellSize.width))
    let row = Int(floor(point.y / cellSize.height))

    self.init(column: col, row: row)
  }
}

extension GridPosition {
  
//  public static func createEdgePositions(
//    edge: GridEdge,
//    rowCount: Int,
//    columnCount: Int
//  ) -> [GridPosition] {
//    switch edge {
//      case .top:
//        return createRow(0, columns: 0..<columnCount)
//      case .bottom:
//        return createRow(rowCount - 1, columns: 0..<columnCount)
//      case .leading:
//        return createColumn(0, rows: 0..<rowCount)
//      case .trailing:
//        return createColumn(columnCount - 1, rows: 0..<rowCount)
//    }
//  }
  
  public static func createRow(_ rowIndex: Int, columns: Range<Int>) -> [GridPosition] {
    columns.map { GridPosition(column: $0, row: rowIndex) }
  }
  
  public static func createColumn(_ columnIndex: Int, rows: Range<Int>) -> [GridPosition] {
    rows.map { GridPosition(column: columnIndex, row: $0) }
  }
  
//  public static func createRow(
//    _ rowIndex: Int,
//    columns: ClosedRange<Int>
//  ) -> [GridPosition] {
//    columns.map { GridPosition(column: $0, row: rowIndex) }
//  }
//  
//  public static func createColumn(
//    _ columnIndex: Int,
//    rows: ClosedRange<Int>
//  ) -> [GridPosition] {
//    rows.map { GridPosition(column: columnIndex, row: $0) }
//  }

  /// Returns a position guaranteed to be within the provided dimensions.
  /// Returns `0` for a row/column if it falls outside these dimensions.
  /// Not suitable for cases where you *only want a position* if it falls inside.
  public func clamped(
    to dimensions: GridDimensions
  ) -> GridPosition {
    let clampedColumn = max(0, min(dimensions.columns - 1, column))
    let clampedRow = max(0, min(dimensions.rows - 1, row))
    return GridPosition(column: clampedColumn, row: clampedRow)
  }

  /// Creates a GridPosition only if contained within the
  /// provided `GridDimensions`
  public static func createIfContained(
    within dimensions: GridDimensions,
    at point: CGPoint,
    cellSize: CGSize
  ) -> GridPosition? {

    guard dimensions.contains(point: point, cellSize: cellSize) else { return nil }
    return GridPosition(point: point, cellSize: cellSize)
  }

  /// Note: zero-based count for internal representation,
  /// one-based for UI
  public static var zero: GridPosition {
    GridPosition(column: 0, row: 0)
  }

  /// Position starting from one, for UI
  public var displayRepresentation: GridPosition {
    GridPosition(column: column + 1, row: row + 1)
  }

  public var isGreaterThanZero: Bool {
    return column > 0 && row > 0
  }

  public var isGreaterThanOrEqualToZero: Bool {
    return column >= 0 && row >= 0
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

  public func neighbour(at edge: Edge) -> GridPosition {
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
    let position = GridPosition(column: newCol, row: newRow)
    print("GridPosition from `offsetting(_ direction: Direction...)`: \(position)")
    self = position
  }

  public func isValidWithin(dimensions: GridDimensions) -> Bool {
    return dimensions.contains(position: self)
  }

  public func moved(
    in direction: Direction,
    by delta: Int = 1,
    gridDimensions: GridDimensions
  ) -> GridPosition {
    let offset = direction.offset(x: column, y: row, by: delta)
    
    /// Wrap raw x/y before creating the new GridPosition, otherwise
    /// the position could get initialised with a negative number
    let wrappedPosition = GridPosition.wrapped(
      column: offset.x,
      row: offset.y,
      in: gridDimensions
    )
    return wrappedPosition
//    let wrappedCol = (offset.x % gridDimensions.columns + gridDimensions.columns) % gridDimensions.columns
//    let wrappedRow = (offset.y % gridDimensions.rows + gridDimensions.rows) % gridDimensions.rows
//    
//    return GridPosition(column: wrappedCol, row: wrappedRow)
  }
  
//  public func moved(
//    in direction: Direction,
//    by delta: Int = 1,
//    gridDimensions: GridDimensions
//  ) -> GridPosition {
//    let offset = direction.offset(x: column, y: row, by: delta)
//
//    let newPosition = GridPosition(column: offset.x, row: offset.y)
//    let wrappedPosition = newPosition.wrapped(
//      columns: gridDimensions.columns,
//      rows: gridDimensions.rows
//    )
//    precondition(
//      wrappedPosition.isValidWithin(dimensions: gridDimensions),
//      "Cell position of \(wrappedPosition) is out of bounds in grid dimensions \(gridDimensions).")
//
//    return wrappedPosition
//  }

//  public func wrapped(columns: Int, rows: Int) -> GridPosition {
//    let wrappedCol = (column % columns + columns) % columns
//    let wrappedRow = (row % rows + rows) % rows
//    return GridPosition(column: wrappedCol, row: wrappedRow)
//  }
  
  /// Column and Row as 'raw' `Int`s are used here, intead of a `GridPosition`,
  /// as `GridPosition` cannot represent negative values
  public static func wrapped(
    column: Int,
    row: Int,
    in dimensions: GridDimensions
  ) -> GridPosition {
    let (columns, rows) = (dimensions.columns, dimensions.rows)
    
    let wrappedCol = (column % columns + columns) % columns
    let wrappedRow = (row % rows + rows) % rows
    return GridPosition(column: wrappedCol, row: wrappedRow)
  }

}

public func + (lhs: GridPosition, rhs: GridPosition) -> GridPosition {
  return GridPosition(column: lhs.column + rhs.column, row: lhs.row + rhs.row)
}

extension GridPosition: CustomStringConvertible {
  public var description: String {
    """
    GridPosition[X: \(column), Y: \(row)]
    """
  }
}
