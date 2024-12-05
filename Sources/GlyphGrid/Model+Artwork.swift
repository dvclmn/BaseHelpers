//
//  Artwork.swift
//  SwiftBox
//
//  Created by Dave Coleman on 29/8/2024.
//

import Foundation

extension GlyphGrid {
  public static func artworkFromCharacters(_ characters: [[Character]]) -> GlyphGrid {
    let height = characters.count
    let width = characters.isEmpty ? 0 : characters[0].count
    
    var cells: [Cell] = []
    cells.reserveCapacity(width * height) // Performance optimization
    
    for (rowIndex, row) in characters.enumerated() {
      for (colIndex, char) in row.enumerated() {
        cells.append(Cell(
          character: char,
          isSelected: false,
          position: GridPosition(row: rowIndex, col: colIndex)
        ))
      }
    }
    
    return GlyphGrid(
      cellSize: CGSize(width: baseFontSize, height: baseFontSize),
      width: width,
      height: height,
      cells: cells
    )
  }
  
  public static let noArt: GlyphGrid = artworkFromCharacters([
    ["N"],
    ["o"],
    [" "],
    ["a"],
    ["r"],
    ["t"],
  ])
  
  public static let empty: GlyphGrid = GlyphGrid(
    cellSize: CGSize(width: baseFontSize, height: baseFontSize),
    width: 0,
    height: 0,
    cells: []
  )
}
