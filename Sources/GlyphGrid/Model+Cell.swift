//
//  Model+Cell.swift
//  Collection
//
//  Created by Dave Coleman on 4/12/2024.
//

import Foundation
import SwiftUI

public extension GlyphGrid {
  
  struct Cell: Equatable, Identifiable, Sendable {
    
    public let id: UUID = UUID()
    public var character: Character
    public var isSelected: Bool
    public var position: GridPosition
    public var colour: Color
    
    public init(
      character: Character = "?",
      isSelected: Bool = false,
      position: GridPosition = .init(),
      colour: Color = .white
    ) {
      self.character = character
      self.isSelected = isSelected
      self.position = position
      self.colour = colour
    }
  }
}
