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
