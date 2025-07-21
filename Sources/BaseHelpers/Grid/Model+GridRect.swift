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
  public init(boundingPositions a: GridPosition, _ b: GridPosition) {

    precondition(a.isPositive && b.isPositive, "GridPositions must be positive (zero or greater). A: \(a), B: \(b)")

    let minRow = min(a.row, b.row)
    let maxRow = max(a.row, b.row)
    let minCol = min(a.column, b.column)
    let maxCol = max(a.column, b.column)

    let origin = GridPosition(column: minCol, row: minRow)

    //    print("GridPosition from `init(boundingPositions a: GridPosition, _ b: GridPosition)`: \(origin)")

    let size = GridDimensions(
      columns: maxCol - minCol + 1,
      rows: maxRow - minRow + 1
    )

    self.init(origin: origin, size: size)
  }

  /// ~~Currently, this dictates that a GridRect cannot be formed outside
  /// of the bounds of the GridDimensions. I need to verify this is
  /// actually what I want.~~
  ///
  /// Edit: Have changed to *clamp*, not return `nil`
  public init(
    fromCGRect rect: CGRect,
    cellSize: CGSize,
    dimensions: GridDimensions
  ) {
    /// Standardise the rect, so origin is always top-left
    let standardisedRect = rect.standardized

    /// Snap the origin to the grid. If returns nil,
    /// then default to a `zero` origin.
    let origin =
      GridPosition(
        point: standardisedRect.origin,
        cellSize: cellSize,
        dimensions: dimensions
      ) ?? GridPosition.zero

    /// Compute the far edge of the selection
    let maxX = standardisedRect.maxX
    let maxY = standardisedRect.maxY

    /// If this comes back `nil`, we use the GridDimension's
    /// `bottomRight` property. Effectively 'clamping' the result
    let endPosition =
      GridPosition(
        point: CGPoint(x: maxX, y: maxY),
        cellSize: cellSize,
        dimensions: dimensions
      ) ?? dimensions.bottomRight

    self.init(boundingPositions: origin, endPosition)
  }
}

extension GridRect {

  /// Iterates over all GridPositions within this GridRect
  public var positions: [GridPosition] {
    (origin.row..<origin.row + size.rows).flatMap { row in
      (origin.column..<origin.column + size.columns).map { col in
        GridPosition(column: col, row: row)
      }
    }
  }

  public func contains(_ position: GridPosition) -> Bool {
    let rowRange = origin.row..<(origin.row + size.rows)
    let colRange = origin.column..<(origin.column + size.columns)
    return rowRange.contains(position.row) && colRange.contains(position.column)
  }

  public func toCGRect(cellSize: CGSize) -> CGRect {
    let originPoint = origin.toCGPoint(cellSize: cellSize)
    let size = CGSize(
      width: CGFloat(self.size.columns) * cellSize.width,
      height: CGFloat(self.size.rows) * cellSize.height
    )
    return CGRect(origin: originPoint, size: size)
  }

  public func clamped(to bounds: GridDimensions) -> GridRect {
    let clampedOrigin = GridPosition(
      column: max(0, min(origin.column, bounds.columns - 1)),
      row: max(0, min(origin.row, bounds.rows - 1)),
    )

    let endRowExclusive = min(origin.row + size.rows, bounds.rows)
    let endColExclusive = min(origin.column + size.columns, bounds.columns)

    let clampedEnd = GridPosition(
      column: max(0, endColExclusive - 1),
      row: max(0, endRowExclusive - 1),
    )

    return GridRect(boundingPositions: clampedOrigin, clampedEnd)
  }

  //  public func clamped(to bounds: GridDimensions) -> GridRect {
  //
  //    let clampedOrigin = GridPosition(
  //      row: max(0, min(origin.row, bounds.rows - 1)),
  //      column: max(0, min(origin.column, bounds.columns - 1))
  //    )
  //
  //    let endRow = min(origin.row + size.rows, bounds.rows)
  //    let endCol = min(origin.column + size.columns, bounds.columns)
  //
  //    let clampedSize = GridDimensions(
  //      columns: max(0, endCol - clampedOrigin.column),
  //      rows: max(0, endRow - clampedOrigin.row)
  //    )
  //
  //    return GridRect(
  //      origin: clampedOrigin,
  //      size: clampedSize,
  //    )
  //  }
}
