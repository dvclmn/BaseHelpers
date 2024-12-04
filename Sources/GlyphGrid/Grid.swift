//
//  Grid.swift
//  SwiftBox
//
//  Created by Dave Coleman on 28/8/2024.
//

import Foundation
import BaseHelpers

public typealias RowsAndColumns = (rows: Int, columns: Int)

public enum DimensionForCell {
  case width, height
}

public extension CGSize {
  func cellsThatFit(_ cellSize: CGSize) -> RowsAndColumns {
    cellsThatFitSize(in: self, cellSize: cellSize)
  }
}

public extension CGFloat {
  func cellsThatFit(
    _ cellSize: CGSize,
    in dimension: DimensionForCell = .width
  ) -> Int {

    var size: CGSize
    var result: Int
    
    switch dimension {
      case .width:
        size = CGSize(width: self, height: .zero)
        result = cellsThatFitSize(in: size, cellSize: cellSize).columns
        
      case .height:
        size = CGSize(width: .zero, height: self)
        result = cellsThatFitSize(in: size, cellSize: cellSize).rows
    }
    
    print("This is the CGFloat result: \(result)")

    return result
  }
}

private func cellsThatFitSize(
  in size: CGSize,
  cellSize: CGSize
) -> RowsAndColumns {
  
  let width: CGFloat = size.width / cellSize.width
  let height: CGFloat = size.height / cellSize.height

  /// IMPORTANT: It's 'unfortunate' that the following feels right
  /// to *say*: "Width and height", and "Rows and column".
  ///
  /// As it conflicts with the below correlation:
  /// *Width* does not correspond to *Rows*, it corresponds
  /// to *Columns*.
  /// *Height* corresponds to *Rows*
  ///
  /// `width` ≈ `columns`
  /// `height` ≈ `rows`
  ///
  let result = (Int(max(1, height)), Int(max(1, width)))
  
  return result
}


public extension GlyphGrid {
  
  func characterCount() -> Int {
    
  var count: Int = 0
    
    if let artwork = self.artwork {
      count = artwork.content.reduce(0) { $0 + $1.count }
    }
    
    return count
  }

//  static func createEmpty(
//    rows: Int,
//    columns: Int,
//    font: GridFont = .menlo
//  ) -> GlyphGrid {
//    let cell = GlyphCell(font: font)
//    let dimensions = GridDimensions(rows: rows, columns: columns)
//    
//    return GlyphGrid(
//      cell: cell,
//      dimensions: dimensions,
//      type: .canvas(Artwork.empty)
//    )
//  }
  
//  static func createWithArtwork(_ artwork: Artwork, font: GridFont = .menlo) -> GlyphGrid {
//    let rows = artwork.count
//    let columns = artwork.map { $0.count }.max() ?? 0
//    
//    let cell = GlyphCell(font: font)
//    let dimensions = GridDimensions(rows: rows, columns: columns)
//    
//    return GlyphGrid(
//      cell: cell,
//      dimensions: dimensions,
//      type: .canvas(artwork)
//    )
//  }
  
//  static func createInterface(rows: Int, columns: Int, font: GridFont = .menlo) -> GlyphGrid {
//    let cell = GlyphCell(font: font)
//    let dimensions = GridDimensions(rows: rows, columns: columns)
//    
//    return GlyphGrid(
//      cell: cell,
//      dimensions: dimensions,
//      type: .interface
//    )
//  }
  

}

public extension GridDimensions {
  
  /// Calculate the number of cells (rows and columns) of a given size (`cellSize`), that can evenly
  /// fit within a window (or other space, sidebar, etc) of a given size (`cgSize`).
  ///
  
  static func calculateDimensions(
    cgSize: CGSize,
    cellSize: CGSize
  ) -> GridDimensions {
    let cgWidthSafe: CGFloat = max(1, cgSize.width)
    let cgHeightSafe: CGFloat = max(1, cgSize.height)
    
    let cellWidthSafe: CGFloat = max(1, cellSize.width)
    let cellHeightSafe: CGFloat = max(1, cellSize.height)
    
    let columns = Int(cgWidthSafe / cellWidthSafe)
    let rows = Int(cgHeightSafe / cellHeightSafe)
    
    return GridDimensions(rows: rows, columns: columns)
  }
  
  
}
