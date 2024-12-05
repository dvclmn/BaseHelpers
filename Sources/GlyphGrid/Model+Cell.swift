//
//  Model+Cell.swift
//  Collection
//
//  Created by Dave Coleman on 4/12/2024.
//

import Foundation

public extension GlyphGrid {
  
  struct Cell: Equatable, Identifiable, Sendable {
    public let id: UUID = UUID()
    public var character: Character
    public var isSelected: Bool
    public var position: GridPosition
    
    public init(
      character: Character = "?",
      isSelected: Bool = false,
      position: GridPosition = .init()
    ) {
      self.character = character
      self.isSelected = isSelected
      self.position = position
    }
  }
}
