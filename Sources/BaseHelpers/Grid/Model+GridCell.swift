//
//  Model+GridCell.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/7/2025.
//

import Foundation

public struct GridCell: GridBase {
  public let id: UUID
  public var character: Character
  public var position: GridPosition
  public var colour: RGBColour

  public init(
    id: UUID = UUID(),
    character: Character,
    position: GridPosition,
    colour: RGBColour
  ) {
    self.id = id
    self.character = character
    self.position = position
    self.colour = colour
  }
}

extension GridCell {
  public static func createBlank(
    at position: GridPosition,
    colour: RGBColour? = nil
  ) -> GridCell {
    return GridCell(character: " ", position: position, colour: colour ?? .white)
  }

  public var isEmpty: Bool { character == " " }
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
    GridCanvas Cell
      Character: \(character.descriptiveName) 
      ArtworkPosition: \(position) 
      Colour: \(colour)
    """
  }
  
  public var descriptionOneLine: String {
    return "GridCanvas Cell: Character `\(character.descriptiveName)`, ArtworkPosition `\(position)`, Colour `\(colour)`"
  }
}
