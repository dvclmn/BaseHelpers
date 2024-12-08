//
//  GlyphGrid.swift
//  SwiftBox
//
//  Created by Dave Coleman on 28/8/2024.
//

import BaseHelpers
import Foundation
import SwiftUI

public struct GlyphGrid: Equatable, Sendable {

  public var cellSize: CGSize
  public var width: Int
  public var height: Int
  public var cells: [Cell]

  public static let baseFontSize: CGFloat = 15

  public init(
    cellSize: CGSize = .defaultCellSize,
    width: Int = 2,
    height: Int = 2,
    cells: [Cell] = []
  ) {
    self.cellSize = cellSize
    self.width = width
    self.height = height
    self.cells = cells
  }
}  // END GlyphGrid

extension GlyphGrid {

  /// Get cell at position
  public func cell(at position: GridPosition) -> Cell? {
    /// Guard against negative indices
    guard position.row >= 0, position.col >= 0,
      /// Guard against exceeding bounds
      position.row < height, position.col < width
    else { return nil }

    let idx = index(row: position.row, column: position.col)
    /// Guard against array bounds
    guard idx >= 0, idx < cells.count else { return nil }

    return cells[idx]
  }

  /// Convert 2D position to 1D index with bounds checking
  public func index(row: Int, column: Int) -> Int {
    assert(row >= 0 && column >= 0, "Negative indices are invalid")
    assert(row < height && column < width, "Position exceeds grid bounds")

    return row * width + column
  }

  /// Convert 1D index to 2D position
  public func position(from index: Int) -> GridPosition {
    let row = index / width
    let column = index % width
    return GridPosition(row: row, col: column)
  }

  public var artworkSize: CGSize {
    CGSize(
      width: CGFloat(self.width) * self.cellSize.width,
      height: CGFloat(self.height) * self.cellSize.height
    )
  }

  public func gridPosition(
    from point: CGPoint,
    within size: CGSize,
    panOffset: CGPoint
  ) -> GridPosition {
    // Calculate the center offset
    let centerOffsetX = (size.width - CGFloat(width) * cellSize.width) / 2
    let centerOffsetY = (size.height - CGFloat(height) * cellSize.height) / 2
    
    // Adjust the point for both centering and panning
    let adjustedPoint = CGPoint(
      x: point.x - centerOffsetX - panOffset.x,
      y: point.y - centerOffsetY - panOffset.y
    )
    
    // Calculate grid position
    let col = Int(floor(adjustedPoint.x / cellSize.width))
    let row = Int(floor(adjustedPoint.y / cellSize.height))
    
    return GridPosition(row: row, col: col)
  }
}

extension CGSize {
  public static let defaultCellSize: CGSize = CGSize(width: 2, height: 4)
}

public struct GridDimensions: Equatable, Sendable {

  private let rows: Int
  private let columns: Int

  public init(
    rows: Int = 8,
    columns: Int = 5
  ) {
    assert(rows >= 1 && columns >= 1, "Cannot initialise grid with values of zero or less.")
    self.rows = max(1, rows)
    self.columns = max(1, columns)
  }

  public static let example: GridDimensions = GridDimensions(rows: 20, columns: 10)
}

public struct GridPosition: Hashable, Equatable, Sendable {
  public let row: Int
  public let col: Int

  public init(
    row: Int = 0,
    col: Int = 0
  ) {
    self.row = row
    self.col = col
  }
}
