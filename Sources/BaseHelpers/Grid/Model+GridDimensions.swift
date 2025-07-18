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

  public static let zero = GridDimensions(columns: 0, rows: 0)

  public init(columns: Int, rows: Int) {
    self.columns = columns
    self.rows = rows
  }

  public init(
    size: CGSize,
    cellSize: CGSize
  ) {

    let widthInCells = Int(size.width / cellSize.width)
    let heightInCells = Int(size.height / cellSize.height)

    /// This means we at least initialise with 1 Cell
    let widthClamped = max(1, widthInCells)
    let heightClamped = max(1, heightInCells)

    self.init(columns: widthClamped, rows: heightClamped)
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
}

extension GridDimensions {
  public func toCGSize(withCellSize cellSize: CGSize) -> CGSize {
    return CGSize(
      width: CGFloat(self.columns) * cellSize.width,
      height: CGFloat(self.rows) * cellSize.height,
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
