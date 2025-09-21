//
//  TabEnum.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 21/9/2025.
//

import SwiftUI

#warning("These (even though they're examples) should be Pickable and Shortcuttable")
enum ExampleTab: String {
//enum ExampleTab: String, Pickable, Shortcuttable {
  static let pickerLabel: QuickLabel = QuickLabel("Example Tab")
  case blim
  case fringent
  case sartim
  case planks
  case blarm
  case frogney

  var name: String {
    self.rawValue.capitalized
  }

  var keyboardShortcut: KeyboardShortcut? {
    switch self {
      case .blim:
        KeyboardShortcut("1", modifiers: .command)
      case .fringent:
        KeyboardShortcut("2", modifiers: .command)
      case .sartim:
        KeyboardShortcut("3", modifiers: .command)
      case .planks:
        KeyboardShortcut("4", modifiers: .command)
      default: nil
    }
  }
  func isTabSelected(_ currentState: Self) -> Bool {
    self == currentState
  }
}
