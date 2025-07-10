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
  let cellSize: CGSize

  /// This expects a `CGRect` that's already mapped
  public init(
    rect: CGRect,
    cellSize: CGSize
  ) {

    assert(rect.width >= 0 && rect.height >= 0, "GridRect initialised with negative dimensions: \(rect)")

    let origin = GridPosition(
      point: rect.origin,
      cellSize: cellSize
    )
    let size = GridDimensions(size: rect.size, cellSize: cellSize)

    self.init(origin: origin, size: size, cellSize: cellSize)
  }

  public init(
    origin: GridPosition,
    size: GridDimensions,
    cellSize: CGSize
  ) {
    self.origin = origin
    self.size = size
    self.cellSize = cellSize
  }

  //  public static func gridRect(
  //    for rect: CGRect,
  //    cellSize: CGSize
  //  ) -> GridRect {
  //    let topLeft = position(at: rect.origin, cellSize: cellSize)
  //    let bottomRight = position(at: CGPoint(x: rect.maxX, y: rect.maxY), cellSize: cellSize)
  //    let width = bottomRight.column - topLeft.column + 1
  //    let height = bottomRight.row - topLeft.row + 1
  //    return GridRect(origin: topLeft, size: GridDimensions(columns: width, rows: height))
  //  }

  /// Creates a GridRect that bounds two GridPositions inclusively
  public init(
    bounding a: GridPosition,
    _ b: GridPosition
  ) {
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
  public var positions: [GridPosition] {
    (origin.row..<origin.row + size.rows).flatMap { row in
      (origin.column..<origin.column + size.columns).map { col in
        GridPosition(row: row, column: col)
      }
    }
  }

  //  public var allPositions: [GridPosition] {
  //    (0..<size.rows).flatMap { r in
  //      (0..<size.columns).map { c in
  //        GridPosition(row: origin.row + r, column: origin.column + c)
  //      }
  //    }
  //  }

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

    return GridRect(origin: clampedOrigin, size: clampedSize)
  }
}
