//
//  Grid.swift
//  SwiftBox
//
//  Created by Dave Coleman on 28/8/2024.
//

import BaseHelpers
import Foundation

public typealias RowsAndColumns = (rows: Int, columns: Int)

extension CGSize {
  public func cellsThatFit(_ cellSize: CGSize) -> RowsAndColumns {
    cellsThatFitSize(in: self, cellSize: cellSize)
  }
}

extension CGFloat {

  public func cellsThatFit(
    _ cellSize: CGSize,
    in dimension: GridDimension = .width
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

    //    print("This is the CGFloat result: \(result)")

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


extension GlyphGrid {

  public func characterCount() -> Int {
    return self.cells.count
  }

  /// Get a row of characters
  func row(_ index: Int) -> ArraySlice<Cell> {
    guard index < height else { return [] }
    let start = index * width
    return cells[start..<(start + width)]
  }
  
  /// Get a column of characters
  func column(_ index: Int) -> [Cell] {
    guard index < width else { return [] }
    return stride(from: index, to: cells.count, by: width).map { cells[$0] }
  }
  
  /// Convert back to 2D array if needed
  func to2DArray() -> [[Cell]] {
    stride(from: 0, to: height * width, by: width).map {
      Array(cells[$0..<min($0 + width, cells.count)])
    }
  }

  
  func debugPrint() {
    print("Grid dimensions: \(width) x \(height)")
    print("Total cells: \(cells.count)")
    
    for row in 0..<height {
      let startIndex = row * width
      let rowCells = cells[startIndex..<(startIndex + width)]
      let rowString = String(rowCells.map { $0.character })
      print(rowString)
    }
  }
  
  func validateDimensions() -> Bool {
    let expectedCellCount = width * height
    let actualCellCount = cells.count
    let dimensionsValid = expectedCellCount == actualCellCount
    
    if !dimensionsValid {
      print("⚠️ Dimension mismatch!")
      print("Expected cell count: \(expectedCellCount)")
      print("Actual cell count: \(actualCellCount)")
      print("Width: \(width), Height: \(height)")
    }
    
    return dimensionsValid
  }
}

extension GridDimensions {

  /// Calculate the number of cells (rows and columns) of a given size (`cellSize`), that can evenly
  /// fit within a window (or other space, sidebar, etc) of a given size (`cgSize`).
  ///

  public static func calculateDimensions(
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
