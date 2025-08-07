//
//  Model+Dimensions.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/7/2025.
//

import Foundation

public struct GridDimensions: GridBase {
  public var columns: Int
  public var rows: Int

  public init(columns: Int, rows: Int) {
    precondition(columns > 0 && rows > 0, "GridDimensions cannot have zero or negative dimensions.")
    self.columns = columns
    self.rows = rows
  }

  public init(
    size: CGSize,
    cellSize: CGSize,
    strategy: SnapStrategy = .round
  ) {
    let counts = size.snappedCellCounts(cellSize: cellSize, strategy: strategy)
    self.init(columns: counts.columns, rows: counts.rows)
  }
}

extension GridDimensions {

  public static let minSize = GridDimensions(
    columns: minCellsAlongLength,
    rows: minCellsAlongLength
  )
  public static let maxSize = GridDimensions(
    columns: maxCellsAlongLength,
    rows: maxCellsAlongLength
  )

  public static let maxCellsAlongLength: Int = 90_000
  public static let minCellsAlongLength: Int = 1

  public var respectsMaxCells: Bool {
    return self.bothLessThan(rhs: Self.maxCellsAlongLength)
  }
  public var respectsMinCells: Bool {
    return self.bothGreaterThan(rhs: Self.minCellsAlongLength)
  }



//  public var bottomRight: GridPosition {
//    return GridPosition(column: columns - 1, row: rows - 1)
//  }
  public var bottomRight: GridPosition? {
    guard columns > 0, rows > 0 else { return nil }
    return GridPosition(column: columns - 1, row: rows - 1)
  }

  public func reducedToFit(within bounds: GridDimensions) -> GridDimensions? {
    let cols = min(self.columns, bounds.columns)
    let rows = min(self.rows, bounds.rows)
    guard cols > 0, rows > 0 else { return nil }
    return GridDimensions(columns: cols, rows: rows)
  }

  public func contains(position: GridPosition) -> Bool {
    return position.column >= 0
    && position.column < columns
    && position.row >= 0
    && position.row < rows
  }
  
  /// Returns `true` if the given point lies within the grid's bounds.
  ///
  /// The grid is assumed to start at origin (0,0) in screen space.
  ///
  /// - Parameters:
  ///   - point: A point in screen-space coordinates.
  ///   - cellSize: The size of each grid cell.
  /// - Returns: `true` if the point is within the grid’s area, else `false`.
  public func contains(
    point: CGPoint,
    cellSize: CGSize
  ) -> Bool {
    let gridSize = toCGSize(withCellSize: cellSize)

    return point.x >= 0
      && point.y >= 0
      && point.x < gridSize.width
      && point.y < gridSize.height
  }


//  public func contains(point: CGPoint, cellSize: CGSize) -> Bool {
//    contains(position(for: point, cellSize: cellSize))
//  }
//  
  public func position(for point: CGPoint, cellSize: CGSize) -> GridPosition {
    GridPosition(
      column: Int(floor(point.x / cellSize.width)),
      row: Int(floor(point.y / cellSize.height))
    )
  }
}

extension GridDimensions {

  public func width(with cellSize: CGSize) -> CGFloat {
    CGFloat(columns) * cellSize.width
  }
  public func height(with cellSize: CGSize) -> CGFloat {
    CGFloat(rows) * cellSize.height
  }

  public func toCGSize(withCellSize cellSize: CGSize) -> CGSize {
    return CGSize(
      width: width(with: cellSize),
      height: height(with: cellSize),
    )
  }

  // MARK: - Greater than
  public func bothGreaterThan(rhs: GridDimensions) -> Bool {
    self.rows > rhs.rows && self.columns > rhs.columns
  }
  public func bothGreaterThan(rhs: Int) -> Bool {
    self.rows > rhs && self.columns > rhs
  }

  // MARK: - Less than
  public func bothLessThan(rhs: GridDimensions) -> Bool {
    self.rows < rhs.rows && self.columns < rhs.columns
  }
  public func bothLessThan(rhs: Int) -> Bool {
    self.rows < rhs && self.columns < rhs
  }
}

extension GridDimensions: CustomStringConvertible {
  public var description: String {
    "Columns: \(columns) Rows: \(rows)"
  }
}

//extension CGSize {
//  public init(fromGridDimensions dimensions: GridDimensions) {
//
//  }
//}
