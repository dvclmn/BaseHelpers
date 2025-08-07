//
//  Model+2DMatrix.swift
//  DrawString
//
//  Created by Dave Coleman on 5/7/2025.
//
//
//  Model+2DMatrix.swift
//  DrawString
//
//  Created by Dave Coleman on 5/7/2025.
//

/// From: https://github.com/eneko/Sudoku/blob/main/Sources/Matrix/Matrix.swift

import BaseHelpers
import Foundation

public struct GridMatrix: Sendable, Hashable, Equatable, Codable {

  public var columns: Int
  public var rows: Int
  public var cells: [GridCell]

  public init(cells: [GridCell], columns: Int) {
    precondition(cells.count % columns == 0, "Matrix must be filled")
    self.columns = columns
    self.rows = cells.count / columns
    self.cells = cells
  }
}

extension GridMatrix {

  var textContent: String {
    let rowsStrings = (0..<rows).map { rowIndex in
      (0..<columns).map { columnIndex in
        self[position: GridPosition(column: columnIndex, row: rowIndex)].character.toString
      }.joined()
    }
    return rowsStrings.joined(separator: "\n")
  }

  /// Rewrites every cell’s `.position` to match its current matrix index.
  public mutating func reindexPositions() {
    for row in 0..<rows {
      for column in 0..<columns {
        let index = row * columns + column
        cells[index].position = GridPosition(column: column, row: row)
      }
    }
  }

  public mutating func addRow(to edge: GridEdge) {
    switch edge {
      case .top:
        let newRow = (0..<columns).map { column in
          GridCell.createBlank(at: .init(column: column, row: 0))
        }
        cells.insert(contentsOf: newRow, at: 0)
        rows += 1
        reindexPositions()

      case .bottom:
        let newRow = (0..<columns).map { column in
          GridCell.createBlank(at: .init(column: column, row: rows))
        }
        cells.append(contentsOf: newRow)
        rows += 1
        reindexPositions()

      default:
        break  // handled elsewhere
    }
  }

  public mutating func removeRow(from edge: GridEdge) {
    precondition(rows > 1, "Cannot remove last row")

    let range: Range<Int>
    switch edge {
      case .top:
        range = 0..<columns
      case .bottom:
        range = cells.count - columns..<cells.count
      default:
        fatalError("Invalid edge for row removal")
    }

    cells.removeSubrange(range)
    rows -= 1
    reindexPositions()
  }

  public mutating func addColumn(to edge: GridEdge) {
    precondition(edge == .leading || edge == .trailing)

    for row in (0..<rows).reversed() {
      let column = (edge == .leading) ? 0 : columns
      let newCell = GridCell.createBlank(at: GridPosition(column: column, row: row))
      let insertIndex = row * columns + (edge == .leading ? 0 : columns)
      cells.insert(newCell, at: insertIndex)
    }

    columns += 1
    reindexPositions()
  }

  public mutating func removeColumn(from edge: GridEdge) {
    precondition(columns > 1, "Cannot remove last column")

    let targetColumn = (edge == .leading) ? 0 : columns - 1

    for row in (0..<rows).reversed() {
      let index = row * columns + targetColumn
      cells.remove(at: index)
    }

    columns -= 1
    reindexPositions()
  }

  // MARK: - Subscripts
  /// Get character at specific grid position
  public subscript(at position: GridPosition) -> GridCell? {
    get {
      guard isValid(position: position) else { return nil }
      return self[row: position.row, column: position.column]
    }
    set {
      guard isValid(position: position), let value = newValue else { return }
      self[row: position.row, column: position.column] = value
    }
  }
  //  public subscript(at position: GridPosition) -> GridCell? {
  //    get {
  //      guard isValid(position: position) else { return nil }
  //      return self[row: position.row, column: position.column]
  //    }
  //    set {
  //      self[row: position.row, column: position.column] = newValue
  //    }
  //
  //  }

  public subscript(row row: Int, column column: Int) -> GridCell {
    get {
      cells[row * columns + column]
    }
    set {
      cells[row * columns + column] = newValue
    }
  }

  //  public subscript(row: Int, column: Int) -> GridCell {
  //    get { cells[row * columns + column] }
  //    set { cells[row * columns + column] = newValue }
  //  }

  /// `let cell = artwork.content[someGridPosition]`
  //  subscript(position position: GridPosition) -> GridCell {
  //    get { self[position.row, position.column] }
  //    set { self[position.row, position.column] = newValue }
  //  }

  //  func getCellIfValid(at position: GridPosition) -> GridCell? {
  //
  //  }

}

extension GridMatrix {

  public func isValid(position: GridPosition) -> Bool {
    position.row >= 0 && position.row < rows && position.column >= 0 && position.column < columns
  }

  mutating func expandToInclude(
    position: GridPosition,
    blank: @autoclosure () -> GridCell
  ) {
    let requiredRows = position.row + 1
    let requiredColumns = max(columns, position.column + 1)

    var newCells: [GridCell] = []

    for row in 0..<requiredRows {
      for column in 0..<requiredColumns {
        if row < rows, column < columns {
          let position = GridPosition(column: column, row: row)
          print("GridPosition from `expandToInclude()`: \(position)")
          newCells.append(self[position: position])
        } else {
          newCells.append(blank())
        }
      }
    }

    self.cells = newCells
    self.columns = requiredColumns
    self.rows = requiredRows
  }

  public var cellRange: Range<Int> {
    return (0..<cells.count)
  }

  public func column(index: Int) -> [GridCell] {
    guard index >= 0 && index < columns else { return [] }
    return stride(from: index, to: cells.count, by: columns).map { cells[$0] }
  }

  public func row(index: Int) -> [GridCell] {
    guard index >= 0 && index < rows else { return [] }
    let start = index * columns
    return Array(cells[start..<start + columns])
  }

  public var allRows: [[GridCell]] {
    (0..<rows).map { row(index: $0) }
  }

  public var allColumns: [[GridCell]] {
    (0..<columns).map { column(index: $0) }
  }

  public func columnIndex(forCell index: Int) -> Int {
    return index % columns
  }

  public func rowIndex(forCell index: Int) -> Int {
    return index / rows
  }
}
