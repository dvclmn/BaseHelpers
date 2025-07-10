//
//  Model+GridRect.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 8/7/2025.
//

import Foundation

public struct GridRect: GridBase {
  public let origin: GridPosition
  public let size: GridDimensions

  /// This expects a `CGRect` that's already mapped
  public init(rect: CGRect, cellSize: CGSize) {

    assert(rect.width >= 0 && rect.height >= 0, "GridRect initialised with negative dimensions: \(rect)")

    let origin = GridPosition(
      point: rect.origin,
      cellSize: cellSize
    )

    let widthInCells = max(0, Int(rect.size.width / cellSize.width))
    let heightInCells = max(0, Int(rect.size.height / cellSize.height))
    let size = GridDimensions(columns: widthInCells, rows: heightInCells)

    self.init(origin: origin, size: size)
  }

  public init(origin: GridPosition, size: GridDimensions) {
    self.origin = origin
    self.size = size
  }

  /// Creates a GridRect that bounds two GridPositions inclusively
  public init(bounding a: GridPosition, _ b: GridPosition) {
    let minRow = min(a.row, b.row)
    let maxRow = max(a.row, b.row)
    let minCol = min(a.column, b.column)
    let maxCol = max(a.column, b.column)

    self.origin = GridPosition(row: minRow, column: minCol)
    self.size = GridDimensions(
      columns: maxCol - minCol + 1,
      rows: maxRow - minRow + 1
    )
  }
}

extension GridRect {
  /// Iterates over all GridPositions within this GridRect
  public var allPositions: [GridPosition] {
    (0..<size.rows).flatMap { r in
      (0..<size.columns).map { c in
        GridPosition(row: origin.row + r, column: origin.column + c)
      }
    }
  }

  public func contains(_ position: GridPosition) -> Bool {
    let rowRange = origin.row..<(origin.row + size.rows)
    let colRange = origin.column..<(origin.column + size.columns)
    return rowRange.contains(position.row) && colRange.contains(position.column)
  }

  func asCGRect(cellSize: CGSize) -> CGRect {
    CGRect(
      x: CGFloat(origin.column) * cellSize.width,
      y: CGFloat(origin.row) * cellSize.height,
      width: CGFloat(size.columns) * cellSize.width,
      height: CGFloat(size.rows) * cellSize.height
    )
  }
}
