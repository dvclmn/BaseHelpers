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

  public init(
    origin: GridPosition,
    size: GridDimensions,
  ) {
    self.origin = origin
    self.size = size
  }

  /// Creates a GridRect that bounds two GridPositions inclusively
  public init(
    bounding a: GridPosition,
    _ b: GridPosition,
  ) {
    let minRow = min(a.row, b.row)
    let maxRow = max(a.row, b.row)
    let minCol = min(a.column, b.column)
    let maxCol = max(a.column, b.column)

    let origin = GridPosition(row: minRow, column: minCol)
    let size = GridDimensions(
      columns: maxCol - minCol + 1,
      rows: maxRow - minRow + 1
    )
    self.init(origin: origin, size: size)
  }

  public init(fromCGRect rect: CGRect, cellSize: CGSize) {
    /// Step 1: Standardise the rect, so origin is always top-left
    let standardisedRect = rect.standardized

    /// Step 2: Snap the origin to the grid
    let origin = GridPosition(
      point: standardisedRect.origin,
      cellSize: cellSize
    )

    /// Step 3: Compute the far edge of the selection
    let maxX = standardisedRect.maxX
    let maxY = standardisedRect.maxY

    let endPosition = GridPosition(
      point: CGPoint(x: maxX, y: maxY),
      cellSize: cellSize
    )

    /// Step 4: Compute size by difference (inclusive selection)
    let columns = endPosition.column - origin.column + 1
    let rows = endPosition.row - origin.row + 1

    let size = GridDimensions(
      columns: max(1, columns),
      rows: max(1, rows)
    )

    /// Step 5: Build and return CGRect
    let gridRect = GridRect(origin: origin, size: size)

    self = gridRect
  }
}

extension GridRect {

  /// Iterates over all GridPositions within this GridRect
  public var positions: [GridPosition] {
    (origin.row..<origin.row + size.rows).flatMap { row in
      (origin.column..<origin.column + size.columns).map { col in
        GridPosition(row: row, column: col)
      }
    }
  }

  public func contains(_ position: GridPosition) -> Bool {
    let rowRange = origin.row..<(origin.row + size.rows)
    let colRange = origin.column..<(origin.column + size.columns)
    return rowRange.contains(position.row) && colRange.contains(position.column)
  }


  public func asCGRect(cellSize: CGSize) -> CGRect {
    CGRect(
      x: CGFloat(origin.column) * cellSize.width,
      y: CGFloat(origin.row) * cellSize.height,
      width: CGFloat(size.columns) * cellSize.width,
      height: CGFloat(size.rows) * cellSize.height
    )
  }

  public func clamped(to bounds: GridDimensions) -> GridRect {

    let clampedOrigin = GridPosition(
      row: max(0, min(origin.row, bounds.rows - 1)),
      column: max(0, min(origin.column, bounds.columns - 1))
    )

    let endRow = min(origin.row + size.rows, bounds.rows)
    let endCol = min(origin.column + size.columns, bounds.columns)

    let clampedSize = GridDimensions(
      columns: max(0, endCol - clampedOrigin.column),
      rows: max(0, endRow - clampedOrigin.row)
    )

    return GridRect(
      origin: clampedOrigin,
      size: clampedSize,
    )
  }
}
