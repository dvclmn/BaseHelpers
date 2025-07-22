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
  private let cellSize: CGSize

  //  public lazy var toCGRect: CGRect = {
  //    toCGRect(cellSize: self.cellSize)
  //  }()

  public init(
    origin: GridPosition,
    size: GridDimensions,
    cellSize: CGSize
  ) {
    self.origin = origin
    self.size = size
    self.cellSize = cellSize
  }

  /// Creates a GridRect that bounds two GridPositions inclusively
  ///
  /// Note: Due to the nature of `GridRect`, it is permitted to create
  /// `GridPosition`(s) that lay at negative coordinates.
  /// Otherwise `GridRect` is too restricted.
  public init(
    boundingPositions a: GridPosition,
    _ b: GridPosition,
    cellSize: CGSize
  ) {

    //    precondition(a.isPositive && b.isPositive, "GridPositions must be positive (zero or greater). A: \(a), B: \(b)")
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

    self.init(
      origin: origin,
      size: size,
      cellSize: cellSize
    )
  }

  public init(
    fromRect rect: CGRect,
    cellSize: CGSize,
    //    clampedTo bounds: GridDimensions? = nil
  ) {
    /// Standardise the rect, so origin is always top-left
    let standardisedRect = rect.standardized

    let origin =
      GridPosition(
        point: standardisedRect.origin,
        cellSize: cellSize,
      )

    let endPosition = GridPosition(
      point: standardisedRect.bottomRight,
      cellSize: cellSize,
    )

    self.init(
      boundingPositions: origin,
      endPosition,
      cellSize: cellSize
    )
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

  public var toCGRect: CGRect {
    let originPoint = origin.toCGPoint(cellSize: cellSize)
    let size = CGSize(
      width: CGFloat(self.size.columns) * cellSize.width,
      height: CGFloat(self.size.rows) * cellSize.height
    )
    return CGRect(origin: originPoint, size: size)
  }

  //  public func toCGRect(cellSize: CGSize) -> CGRect {
  //    let originPoint = origin.toCGPoint(cellSize: cellSize)
  //    let size = CGSize(
  //      width: CGFloat(self.size.columns) * cellSize.width,
  //      height: CGFloat(self.size.rows) * cellSize.height
  //    )
  //    return CGRect(origin: originPoint, size: size)
  //  }

  //  public static func create(clampedTo bounds: GridDimensions) -> GridRect {
  //
  //  }

  public static func createIfContained(
    within bounds: GridDimensions,
    fromRect rect: CGRect,
    cellSize: CGSize,
  ) -> GridRect? {
    /// Standardise the rect, so origin is always top-left
    let standardisedRect = rect.standardized

    guard
      let origin = GridPosition.createIfContained(
        within: bounds,
        at: standardisedRect.origin,
        cellSize: cellSize
      )
    else { return nil }

    guard
      let end = GridPosition.createIfContained(
        within: bounds,
        at: standardisedRect.bottomRight,
        cellSize: cellSize
      )
    else { return nil }

    return GridRect(
      boundingPositions: origin,
      end,
      cellSize: cellSize
    )

  }

}
