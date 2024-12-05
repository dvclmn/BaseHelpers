//
//  GlyphGrid.swift
//  SwiftBox
//
//  Created by Dave Coleman on 28/8/2024.
//

import Foundation

public typealias GridArtwork = [[GlyphGrid.Cell]]

public struct GlyphGrid: Equatable, Sendable {

  public var cellSize: CGSize
  public var type: GridType
  public var artwork: GridArtwork
  public var dimensions: GridDimensions

  public static let baseFontSize: CGFloat = 15
  
  public init(
    cellSize: CGSize,
    artwork: GridArtwork = [],
    dimensions: GridDimensions = GridDimensions(),
    type: GridType
  ) {
    self.cellSize = cellSize
    self.artwork = artwork
    self.dimensions = dimensions
    self.type = type
  }
  
} // END GlyphGrid

public extension GlyphGrid {
  
  
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



public enum GridType: Equatable, Sendable {
  case canvas
  case interface
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


