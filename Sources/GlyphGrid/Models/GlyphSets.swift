//
//  Glyphs.swift
//  Collection
//
//  Created by Dave Coleman on 7/12/2024.
//

public protocol Glyph {
  var character: Character { get }
}

public protocol RotatableGlyph: Glyph {
  var rotatedCharacter: Character { get }
  
  func rotated(in direction: RotationDirection) -> Character
}

public protocol FlippableGlyph: Glyph {
  func flipped(horizontally: Bool) -> Character
}


public enum GlyphOrientation {
  case `default`
  case quarter
  case half
  case threeQuarter
}

public enum RotationDirection {
  case clockwise
  case counterClockwise
}


// Example implementation
struct LineGlyph: RotatableGlyph {
  let character: Character
  var rotatedCharacter: Character {
    character // Will be updated based on rotation
  }
  
  private static let rotationSequence: [Character] = ["|", "/", "-", "\\"]
  
  func rotated(in direction: RotationDirection) -> Character {
    guard let currentIndex = Self.rotationSequence.firstIndex(of: character) else {
      return character // Return original if not in sequence
    }
    
    let count = Self.rotationSequence.count
    let newIndex: Int
    
    switch direction {
      case .clockwise:
        newIndex = (currentIndex + 1) % count
      case .counterClockwise:
        newIndex = (currentIndex - 1 + count) % count
    }
    
    return Self.rotationSequence[newIndex]
  }
}

// Usage example
struct BoxGlyph: RotatableGlyph {
  let character: Character
  var rotatedCharacter: Character {
    character
  }
  
  private static let rotationSequence: [Character] = ["└", "┌", "┐", "┘"]
  
  func rotated(in direction: RotationDirection) -> Character {
    guard let currentIndex = Self.rotationSequence.firstIndex(of: character) else {
      return character
    }
    
    let count = Self.rotationSequence.count
    let newIndex: Int
    
    switch direction {
      case .clockwise:
        newIndex = (currentIndex + 1) % count
      case .counterClockwise:
        newIndex = (currentIndex - 1 + count) % count
    }
    
    return Self.rotationSequence[newIndex]
  }
}


struct GlyphManager {
  static func createRotatableGlyph(for character: Character) -> RotatableGlyph? {
    switch character {
      case "|", "/", "-", "\\":
        return LineGlyph(character: character)
      case "└", "┌", "┐", "┘":
        return BoxGlyph(character: character)
      default:
        return nil
    }
  }
}
