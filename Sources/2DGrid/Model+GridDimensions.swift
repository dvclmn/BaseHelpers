//
//  Model+Dimensions.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/7/2025.
//

import Foundation

public struct GridDimensions: ModelBase {
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
    let dimensions = size.cellSnappedDimensions(
      cellSize: cellSize,
      strategy: strategy
    )
    self.init(columns: dimensions.columns, rows: dimensions.rows)
  }
}

// MARK: - Containment Methods
extension GridDimensions {
  /// Checks if a point (in pixel coordinates) falls within the grid bounds
  public func contains(point: CGPoint, cellSize: CGSize) -> Bool {
    let gridSize = toCGSize(withCellSize: cellSize)
    return point.x >= 0
      && point.y >= 0
      && point.x < gridSize.width
      && point.y < gridSize.height
  }

  /// Checks if a grid position is within valid bounds
  public func contains(position: GridPosition) -> Bool {
    return position.column >= 0 && position.column < columns && position.row >= 0 && position.row < rows
  }

  /// Convenience method: converts point to position and checks if it's valid
  public func containsValidPosition(for point: CGPoint, cellSize: CGSize) -> Bool {
    let gridPosition = position(for: point, cellSize: cellSize)
    return contains(position: gridPosition)
  }
}

// MARK: - Coordinate Conversion
extension GridDimensions {
  public func position(for point: CGPoint, cellSize: CGSize) -> GridPosition {
    GridPosition(
      column: Int(floor(point.x / cellSize.width)),
      row: Int(floor(point.y / cellSize.height))
    )
  }
}

// MARK: - Size Calculations
extension GridDimensions {
  public func width(with cellSize: CGSize) -> CGFloat {
    CGFloat(columns) * cellSize.width
  }
  
  public func height(with cellSize: CGSize) -> CGFloat {
    CGFloat(rows) * cellSize.height
  }
  
  public func toCGSize(withCellSize cellSize: CGSize) -> CGSize {
    CGSize(
      width: width(with: cellSize),
      height: height(with: cellSize)
    )
  }
}

// MARK: - Additional Convenience Methods
extension GridDimensions {
  /// Total number of cells in the grid
  public var cellCount: Int {
    columns * rows
  }
  
  /// All valid positions in the grid
  public var allPositions: [GridPosition] {
    (0..<rows).flatMap { row in
      (0..<columns).map { column in
        GridPosition(column: column, row: row)
      }
    }
  }
  
  /// Check if this grid can fit within another grid
  public func fits(within other: GridDimensions) -> Bool {
    return self.columns <= other.columns && self.rows <= other.rows
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


}

extension GridDimensions {

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
