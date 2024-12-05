//
//  GlyphGrid.swift
//  SwiftBox
//
//  Created by Dave Coleman on 28/8/2024.
//

import Foundation
import BaseHelpers

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
} // END GlyphGrid

public extension GlyphGrid {
  
  /// Convert 2D position to 1D index
  func index(row: Int, column: Int) -> Int {
    return row * width + column
  }
  
  /// Convert 1D index to 2D position
  func position(from index: Int) -> GridPosition {
    let row = index / width
    let column = index % width
    return GridPosition(row: row, col: column)
  }
  
  /// Get cell at position
  func cell(at position: GridPosition) -> Cell? {
    guard position.row < height && position.col < width else { return nil }
    return cells[index(row: position.row, column: position.col)]
  }
  
  
  
  
//  func cell(at position: GridPosition) -> Cell? {
//    guard position.row >= 0 && position.row < dimensions.rows,
//          position.col >= 0 && position.col < dimensions.columns else {
//      return nil
//    }
//    let idx = index(for: position)
//    return artwork[idx]
//  }
//  
//  
//  
//  func index(for position: GridPosition) -> Int {
//    return position.row * dimensions.columns + position.col
//  }
  
  
//  func dimensionsForArtwork(_ artwork: GridArtwork) -> GridDimensions {
//      let rows = artwork.count
//      let columns = artwork.isEmpty ? 0 : artwork[0].count
//      return GridDimensions(rows: rows, columns: columns)
//  }
}

public extension CGSize {
  static let defaultCellSize: CGSize = CGSize(width: 2, height: 4)
}

public struct GridDimensions: Equatable, Sendable {
  
  private var _rows: Int
  private var _columns: Int
  
  public var minValue: Int
  
  public var rows: Int {
    get { _rows }
    set { _rows = max(minValue, newValue) }
  }
  
  public var columns: Int {
    get { _columns }
    set { _columns = max(minValue, newValue) }
  }
  
  public init(
    rows: Int = 8,
    columns: Int = 5,
    minValue: Int = 2
  ) {
    self.minValue = minValue
    self._rows = max(minValue, rows)
    self._columns = max(minValue, columns)
  }
  
  public static let example: GridDimensions = GridDimensions(rows: 20, columns: 10)
}



//public enum GridType: Equatable, Sendable {
//  case canvas
//  case interface
//}



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


