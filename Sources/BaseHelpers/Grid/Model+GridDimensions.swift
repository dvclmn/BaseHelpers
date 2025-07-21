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

  public static let minSize = GridDimensions(columns: 1, rows: 1)

  public init(columns: Int, rows: Int) {
    precondition(columns > 0 && rows > 0, "GridDimensions cannot have zero or negative dimensions.")
    self.columns = columns
    self.rows = rows
  }

  public init(
    size: CGSize,
    cellSize: CGSize
  ) {
    let widthInCells = Int(size.width / cellSize.width)
    let heightInCells = Int(size.height / cellSize.height)

    self.init(columns: widthInCells, rows: heightInCells)
  }
}

extension GridDimensions {
  public static let maxCellsAlongLength: Int = 90_000
  public static let minCellsAlongLength: Int = 1

  public var respectsMaxCells: Bool {
    return self.bothLessThan(rhs: Self.maxCellsAlongLength)
  }
  public var respectsMinCells: Bool {
    return self.bothGreaterThan(rhs: Self.minCellsAlongLength)
  }

  public func contains(_ position: GridPosition) -> Bool {
    return position.row >= 0
      && position.row < rows
      && position.column >= 0
      && position.column < columns
  }
  
  public var bottomRight: GridPosition {
    return GridPosition(column: columns - 1, row: rows - 1)
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
  
  
}

extension GridDimensions {
  public func toCGSize(withCellSize cellSize: CGSize) -> CGSize {
    return CGSize(
      width: CGFloat(columns) * cellSize.width,
      height: CGFloat(rows) * cellSize.height,
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
