//
//  GlyphSet.swift
//  BoxCore
//
//  Created by Dave Coleman on 12/9/2024.
//

public extension BoxCore {
  
  enum GlyphSet: Sendable {
    case base([GlyphType: Character])
    indirect case fallback([GlyphType: Character], GlyphSet)
    
    func character(for glyphType: GlyphType) -> Character {
      switch self {
        case .base(let glyphMap):
          return characterFromMap(glyphMap, for: glyphType) ?? "?"
        case .fallback(let glyphMap, let fallbackSet):
          return characterFromMap(glyphMap, for: glyphType) ?? fallbackSet.character(for: glyphType)
      }
    }
    
    
    private func characterFromMap(_ glyphMap: [GlyphType: Character], for glyphType: GlyphType) -> Character? {
      // Check for exact match
      if let char = glyphMap[glyphType] {
        return char
      }
      
      // For join and corner, try equivalent interior variants first
      switch glyphType {
        case .join(_, _, let type):
          if let char = glyphMap[.join(x: .interior, y: .interior, type: type)] {
            return char
          }
        case .corner(_, let type):
          if let char = glyphMap[.corner(location: .interior, type: type)] {
            return char
          }
        default:
          break
      }
      
      // Check for fallback within the same map
      if let fallbackType = glyphType.fallback,
         let fallbackChar = glyphMap[fallbackType] {
        return fallbackChar
      }
      
      // For join and corner, try falling back to exterior variants
      switch glyphType {
        case .join(_, _, let type):
          return glyphMap[.join(x: .exterior, y: .exterior, type: type)]
        case .corner(_, let type):
          return glyphMap[.corner(location: .exterior, type: type)]
        default:
          return nil
      }
    }
    
    
  }
  
  
}


