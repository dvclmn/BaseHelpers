//
//  Model+Dimensions.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/7/2025.
//

public struct GridDimensions: GridBase {
  public var columns: Int
  public var rows: Int

  public init(columns: Int, rows: Int) {
    self.columns = columns
    self.rows = rows
  }
}

extension GridDimensions {
  static let maxCellsAlongLength: Int = 90_000
  static let minCellsAlongLength: Int = 1

  var respectsMaxCells: Bool {
    return self < Self.maxCellsAlongLength
  }
  var respectsMinCells: Bool {
    return self > Self.minCellsAlongLength
  }

  func contains(_ position: GridPosition) -> Bool {
    return position.row >= 0
      && position.row < rows
      && position.column >= 0
      && position.column < columns
  }
}

// MARK: - Greater than
public func > (lhs: GridDimensions, rhs: GridDimensions) -> Bool {
  lhs.rows > rhs.rows || lhs.columns > rhs.columns
}
public func > (lhs: GridDimensions, rhs: Int) -> Bool {
  lhs.rows > rhs || lhs.columns > rhs
}

// MARK: - Less than
public func < (lhs: GridDimensions, rhs: GridDimensions) -> Bool {
  lhs.rows < rhs.rows || lhs.columns < rhs.columns
}
public func < (lhs: GridDimensions, rhs: Int) -> Bool {
  lhs.rows < rhs || lhs.columns < rhs
}
