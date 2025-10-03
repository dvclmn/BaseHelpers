//
//  KeyPress.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 13/9/2025.
//

import SwiftUI

public extension KeyPress {
  var displayString: String {
    return """
    
    Key Press:
    ----------
    \(self.key.symbolCapitalised)\(self.modifiers.symbols)
    Phase: \(phase.name)
    
    
    """
  }
}


public extension KeyPress.Phases {
  var name: String {
    switch self {
      case .down: "Down"
      case .repeat: "Repeat"
      case .up: "Up"
      case .all: "All"
      default: "Unknown"
    }
  }
}
