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
    
    public init(
      character: Character = "?",
      isSelected: Bool = false
    ) {
      self.character = character
      self.isSelected = isSelected
    }
  }
}

public extension GlyphGrid.Cell {
  
  
}
