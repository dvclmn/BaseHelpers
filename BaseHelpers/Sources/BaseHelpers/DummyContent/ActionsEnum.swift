//
//  ActionsEnum.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 21/9/2025.
//

import SwiftUI

extension DummyContent {
  
  public enum Actions: String, CaseIterable, Identifiable {
    case exit
    case edit
    case save

    public var id: String {
      rawValue
    }
    var name: String {
      switch self {
        case .save: "Save & Exit"
        case .exit: "Exit"
        case .edit: "Edit"
      }
    }

    var shortcut: KeyboardShortcut {
      switch self {
        case .save:
          .init(.return, modifiers: .command)
        case .exit:
          .init(.escape)
        case .edit:
          .init("E", modifiers: [.command, .option])
      }
    }
  }
}
