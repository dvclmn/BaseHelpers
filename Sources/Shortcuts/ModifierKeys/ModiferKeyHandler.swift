//
//  File.swift
//
//
//  Created by Dave Coleman on 23/7/2024.
//

import Foundation
import SwiftUI


#if os(macOS)


public protocol ModifierKeyCollection {
  func holding(_ modifiers: NSEvent.ModifierFlags...) -> Bool
  func holding(_ modifiers: [NSEvent.ModifierFlags]) -> Bool
}

extension NSEvent.ModifierFlags: @retroactive Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(rawValue)
  }
}



extension Set: ModifierKeyCollection where Element == NSEvent.ModifierFlags {
  public func holding(_ modifiers: NSEvent.ModifierFlags...) -> Bool {
    holding(modifiers)
  }
  
  public func holding(_ modifiers: [NSEvent.ModifierFlags]) -> Bool {
    modifiers.allSatisfy { self.contains($0) }
  }
}

extension Set where Element == NSEvent.ModifierFlags {
  public func holding(_ modifier: NSEvent.ModifierFlags) -> Bool {
    contains(modifier)
  }
}


//public extension KeyboardShortcut {
//  
//  func printString(includesKeyLabel: Bool = false) -> String {
//    
//    var keyEquivalent: String {
//      if let keySymbol = self.key.keyInfo() {
//        let literal: String = keySymbol.symbolLiteral
//        
//        if includesKeyLabel, let label = keySymbol.label {
//          return literal + label
//        } else {
//          return literal
//        }
//        
//      } else {
//        return self.key.character.description.uppercased()
//      }
//    } // END
//    
//    var modifierString: String {
//      
//      var modifiers: String = ""
//      
//      for string in self.modifiers.toModifierString(ofType: .literal) {
//        modifiers += string
//      }
//      
//      return modifiers
//    }
//    
//    return modifierString + keyEquivalent
//  }
//}


#endif
