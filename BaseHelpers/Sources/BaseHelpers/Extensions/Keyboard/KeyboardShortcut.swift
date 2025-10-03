//
//  KeyboardShortcut.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 16/6/2025.
//

import SwiftUI

public enum KeyboardElementDisplayStyle {
  case name(isAbbreviated: Bool = true) // E.g. Return
  case symbolLiteral // E.g. 􀅇
  
  public var isSymbol: Bool {
    if case .symbolLiteral = self { return true }
    return false
  }
  
  public var isAbbreviated: Bool {
    switch self {
      case .name(let abbr): return abbr
      case .symbolLiteral: return false
    }
  }
}

extension KeyboardShortcut {
  public func displayString(
    keyStyle: KeyboardElementDisplayStyle = .symbolLiteral,
    modifierStyle: KeyboardElementDisplayStyle = .symbolLiteral,
  ) -> String {
    let modifiers: String = modifierStyle.isSymbol ? modifiers.symbols : modifiers.names
    let key: String = keyStyle.isSymbol ? key.symbolLiteral.toString.uppercased() : key.name(isAbbreviated: keyStyle.isAbbreviated)
    return modifiers + key
  }
}
