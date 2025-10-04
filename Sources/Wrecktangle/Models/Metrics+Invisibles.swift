//
//  Characters.swift
//  Helpers
//
//  Created by Dave Coleman on 22/8/2024.
//

import Foundation
import SwiftUI

public extension BoxCore {
  
  enum Invisibles {
    
    case line
    case space
    case tab
    case padding
    case paddingAlt
    
    public enum LineType {
      case new
      case end
    }
    
    public var character: Character {
      switch self {
        case .line: "¬"
//        case .line(.end): "¶"
        case .space: "/"
        case .tab: "→"
        case .padding: ","
        case .paddingAlt: "."
      }
    }
    
  }
  
  func invisibleIfNeeded(
    _ character: Invisibles,
    fallBackCharacter: Character = " " // I.e. character to return if invisibles are not needed
  ) -> Character {
    
    let isShowing = self.config.metrics.invisibles
    
    let result = isShowing ? character.character : fallBackCharacter
    
    return result
  }
  
}
