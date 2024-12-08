//
//  GlyphGrid.swift
//  SwiftBox
//
//  Created by Dave Coleman on 28/8/2024.
//

import BaseHelpers
import Foundation
import SwiftUI
import BaseStyles

public struct GlyphGrid: Equatable, Sendable {

  public var cellSize: CGSize
  public var width: Int
  public var height: Int
  public var cells: [Cell]
  
  public var foreground: Color = Swatch.lightGrey.colour
  public var background: Color = Swatch.darkPlum.colour
  
  public var original: String = ""

  public static let baseFontSize: CGFloat = 15

  public init(
    cellSize: CGSize = .defaultCellSize,
    width: Int = 2,
    height: Int = 2,
    cells: [Cell] = [],
    original: String = ""
  ) {
    self.cellSize = cellSize
    self.width = width
    self.height = height
    self.cells = cells
    self.original = original
  }
  
  public init(content: String) {
    self = GlyphGrid.createGlyphGrid(from: content)
  }

  private static func createGlyphGrid(from content: String) -> GlyphGrid {
    let lines = content.split(separator: "\n")
    
    /// Calculate dimensions
    let height = lines.count
    let width = lines.map { $0.count }.max() ?? 1
    
    /// Create cells array with proper capacity
    var cells: [GlyphGrid.Cell] = []
    cells.reserveCapacity(width * height)
    
    /// Process each line
    for (rowIndex, line) in lines.enumerated() {
      let rowCells = processRow(
        line: line,
        rowIndex: rowIndex,
        maxWidth: width
      )
      cells.append(contentsOf: rowCells)
    }
    
    return GlyphGrid(
      cellSize: CGSize(width: GlyphGrid.baseFontSize, height: GlyphGrid.baseFontSize),
      width: width,
      height: height,
      cells: cells,
      original: content
    )
  }
  
  private static func processRow(
    line: Substring,
    rowIndex: Int,
    maxWidth: Int
  ) -> [GlyphGrid.Cell] {
    
    var rowCells: [GlyphGrid.Cell] = []
    rowCells.reserveCapacity(maxWidth)
    
    /// Add actual characters
    for (columnIndex, character) in line.enumerated() {
      rowCells.append(GlyphGrid.Cell(
        character: character,
        position: GridPosition(row: rowIndex, col: columnIndex)
      ))
    }
    
    /// Pad with spaces if needed
    let padding: Int = maxWidth - line.count
    if padding > 0 {
      for colIndex in line.count..<maxWidth {
        rowCells.append(GlyphGrid.Cell(
          character: " ",
          position: GridPosition(row: rowIndex, col: colIndex)
        ))
      }
    }
    
    return rowCells
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
  
  public func getCellRect(
    for position: GridPosition,
    cellSize: CGSize
  ) -> CGRect {
    CGRect(
      x: (CGFloat(position.col) * cellSize.width),
      y: (CGFloat(position.row) * cellSize.height),
      width: cellSize.width,
      height: cellSize.height
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
