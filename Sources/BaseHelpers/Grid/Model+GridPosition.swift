//
//  Model+GridPosition.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/7/2025.
//

import Foundation

/// Represents an integer-based position in a 2D Grid (rows and columns)
public struct GridPosition: GridBase {
  public let row: Int
  public let column: Int

  public init(row: Int, column: Int) {
    self.row = row
    self.column = column
  }

  /// `point` must already be mapped to local Canvas space
  public init(
    point: CGPoint,
    cellSize: CGSize
  ) {
    let position = GridPosition.fromCGPoint(point, at: cellSize)
    self = position
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

  /// `cellSize` is the width and height in points
  /// of a single cell in the current `GridCanvas`.
  /// It is not affected by zoom, it operates in local
  /// Canvas Space
  public static func fromCGPoint(
    _ point: CGPoint,
    at cellSize: CGSize
  ) -> GridPosition {
    let row = Int(floor(point.y / cellSize.height))
    let col = Int(floor(point.x / cellSize.width))

    return GridPosition(row: row, column: col)
  }

  public func toIndex(columns: Int) -> Int {
    row * columns + column
  }

  public static var zero: GridPosition {
    GridPosition(row: 0, column: 0)
  }
  /// Basic offset methods
  public func offsetBy(row deltaRow: Int, col deltaCol: Int) -> GridPosition {
    GridPosition(row: row + deltaRow, column: column + deltaCol)
  }

  public mutating func offsetting(by delta: GridPosition) {
    let current = self
    self = current + delta
  }

  public mutating func offsetting(_ direction: Direction, by delta: Int = 1) {
    let (newCol, newRow) = direction.offset(x: column, y: row, by: delta)
    self = GridPosition(row: newRow, column: newCol)
  }
  
  public func isValidWithin(grid: GridDimensions) -> Bool {
    return grid.contains(self)
  }

}

public func + (lhs: GridPosition, rhs: GridPosition) -> GridPosition {
  return GridPosition(
    row: lhs.row + rhs.row,
    column: lhs.column + rhs.column
  )
}

extension GridPosition: CustomStringConvertible {
  public var description: String {
    """
    GridPosition[X: \(column), Y: \(row)]
    """
  }
}
