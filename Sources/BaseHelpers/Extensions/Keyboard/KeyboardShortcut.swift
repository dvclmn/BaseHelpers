//
//  KeyboardShortcut.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 16/6/2025.
//

import SwiftUI

extension KeyboardShortcut {
  public var displayString: String {
    let modifiers: String = self.modifiers.symbols
    let key: String = self.key.symbolLiteral.toString.uppercased()
    return modifiers + key
  }
}
