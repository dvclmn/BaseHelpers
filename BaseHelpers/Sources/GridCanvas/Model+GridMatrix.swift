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

  public init(_ content: String) {
    let cells = GridCell.generateCells(from: content)
    self.init(cells: cells, columns: content.longestLineLength)
  }
}

// MARK: - Edit Artwork
extension GridMatrix {
  /// When a user starts drawing in previously empty space:
  public mutating func setCharacter(_ char: Character, at position: GridPosition) {
    expandToInclude(position: position, blank: GridCell.createBlank(at: position))
    self[at: position] = GridCell(character: char, position: position)
  }

  public mutating func clearCells(at positions: [GridPosition]) {
    for position in positions {
      self[at: position]?.character = " "
    }
  }

}

// MARK: - Add/Remove

extension GridMatrix {

  public mutating func resize(
    by delta: GridDelta,
    at edges: GridEdge.Set
  ) {
    for edge in GridEdge.allCases where edges.contains(GridEdge.Set(edge)) {
      switch edge.gridAxis {
        case .row:
          if delta.rows > 0 {
            addRows(to: edge, count: delta.rows)
          } else if delta.rows < 0 {
            removeRows(from: edge, count: -delta.rows)
          }
        case .column:
          if delta.columns > 0 {
            addColumns(to: edge, count: delta.columns)
          } else if delta.columns < 0 {
            removeColumns(from: edge, count: -delta.columns)
          }
      }
    }
  }

  public mutating func resize(
    by delta: GridDelta,
    at boundaryPoint: GridBoundaryPoint
  ) {
    let edges = boundaryPoint.affectedEdges
    self.resize(by: delta, at: edges)
  }

  mutating func addColumns(to edge: GridEdge, count: Int = 1) {
    for _ in 0..<count { addColumn(to: edge) }
  }

  mutating func removeColumns(from edge: GridEdge, count: Int = 1) {
    precondition(columns > count, "Cannot remove \(count) columns; only \(columns) available")
    for _ in 0..<count { removeColumn(from: edge) }
  }

  mutating func addRows(to edge: GridEdge, count: Int = 1) {
    for _ in 0..<count { addRow(to: edge) }
  }

  mutating func removeRows(from edge: GridEdge, count: Int = 1) {
    precondition(rows > count, "Cannot remove \(count) rows; only \(rows) available")
    for _ in 0..<count { removeRow(from: edge) }
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

}

// MARK: - Metadata
extension GridMatrix {

  /// Get a specific row of text
  func row(_ index: Int) -> String? {
    guard index >= 0, index < rowCount else { return nil }
    let row: [[GridCell]] = self.allRows

    let rowCharacters = row[index].map(\.character)
    return String(rowCharacters)
  }

  /// Get a specific column of text
  func column(_ index: Int) -> [Character] {
    guard index >= 0, index < columnCount else { return [] }

    let column = self.column(index: index)
    let columnCharacters = column.map(\.character)
    return columnCharacters

  }

  public var dimensions: GridDimensions {
    GridDimensions(columns: columnCount, rows: rowCount)
  }

  public var cellCount: Int { cells.count }
  public var rowCount: Int { allRows.count }
  public var columnCount: Int { allColumns.count }

  public var textContent: String {
    let rowsStrings = (0..<rows).map { rowIndex in
      (0..<columns).map { columnIndex in
        let position = GridPosition(column: columnIndex, row: rowIndex)
        return self[at: position]?.character.toString ?? " "
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
  
  public subscript(row row: Int, column column: Int) -> GridCell {
    get {
      cells[row * columns + column]
    }
    set {
      cells[row * columns + column] = newValue
    }
  }

}

// MARK: - Cell Access
extension GridMatrix {

  func cells(at positions: [GridPosition]) -> [GridCell] {
    var cells: [GridCell] = []
    for position in positions {
      if let cell = self[at: position] {
        cells.append(cell)
      }
    }
    return cells
  }

  /// Get all positions containing a specific character
  func positions(of character: Character) -> [GridPosition] {
    var positions: [GridPosition] = []

    let rows: [[GridCell]] = self.allRows
    //    let columns: [[GridCell]] = self.content.allColumns
    for (rowIndex, line) in rows.enumerated() {
      for (columnIndex, char) in line.enumerated() where char.character == character {
        positions.append(GridPosition(column: columnIndex, row: rowIndex))
      }
    }
    return positions
  }

  /// Get all cells within specified bounds
  func cells(in bounds: GridDimensions) -> [GridCell] {
    var cells: [GridCell] = []
    for row in 0..<bounds.rows {
      for column in 0..<bounds.columns {
        let position = GridPosition(column: column, row: row)
        if let cell = self[at: position] {
          cells.append(cell)
        }
      }
    }
    return cells
  }

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
          guard let cell = self[at: position] else { return }
          newCells.append(cell)
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

extension GridMatrix: CustomStringConvertible {
  public var description: String {
    let result: String = """
      /// Matrix of GridCells ///
      Counts: Columns[\(self.columns)], Rows[\(self.rows)], Cells[\(self.cells.count)]
      Content: \(cells)

      """
    return result
  }

}

extension String {
  static var blankArtwork: String {
    let blankCharacter: String = " "
    return String(repeating: "\(blankCharacter)\n", count: 6)

  }
}
