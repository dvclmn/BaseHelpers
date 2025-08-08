//
//  Model+GridCell.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/7/2025.
//

import Foundation

public struct GridCell: GridBase {
  public var id: GridPosition { position }
  public var character: Character
  public var position: GridPosition
  public var colour: RGBColour

  public init(
    character: Character,
    position: GridPosition,
    colour: RGBColour = .white
  ) {
    self.character = character
    self.position = position
    self.colour = colour
  }
}

extension GridCell {

  public static func createBlank(
    at position: GridPosition,
    colour: RGBColour = .white,
    character: Character = " "
  ) -> GridCell {
    return GridCell(character: character, position: position, colour: colour)
  }

  public var isEmpty: Bool { character == " " }

  // MARK: - Convert Text to Cells
  public static func generateCells(from text: String) -> [GridCell] {
    let dimensions = text.gridDimensions
    let lines = text.substringLines(subsequenceStrategy: .omitLastLineIfEmpty)

    return lines.enumerated().flatMap {
      rowIndex,
      line in
      createRowCells(
        from: line,
        rowIndex: rowIndex,
        targetWidth: dimensions.columns
      )
    }
  }

  private static func createRowCells(
    from line: Substring,
    rowIndex: Int,
    targetWidth: Int
  ) -> [GridCell] {
    let characterCells = line.enumerated().map { columnIndex, character in
      GridCell(
        character: character,
        position: GridPosition(column: columnIndex, row: rowIndex),
        colour: .white
      )
    }

    let paddingCells = (line.count..<targetWidth).map { columnIndex in
      let position = GridPosition(column: columnIndex, row: rowIndex)
      return GridCell.createBlank(at: position)
    }

    return characterCells + paddingCells
  }

}

enum GridCellError: LocalizedError {
  case outOfBounds(index: Int)
  case indexOutOfRange(index: Int, count: Int)

  var errorDescription: String? {
    switch self {
      case .outOfBounds(let index):
        return "Adjusted index \(index) is out of bounds"
      case .indexOutOfRange(let index, let count):
        return "Cell index \(index) is out of range (valid range: 0...\(count-1))"
    }
  }
}

extension GridCell: CustomStringConvertible {

  public var description: String {
    """

    GridCell: 
      - Character \"\(character.descriptiveName)\"
      - \(position)

    """

  }

}
