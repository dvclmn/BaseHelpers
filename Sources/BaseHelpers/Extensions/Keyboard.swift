//
//  KeyEquivalent.swift
//  Collection
//
//  Created by Dave Coleman on 23/12/2024.
//

import SwiftUI

public extension KeyEquivalent {

  var name: String {
    switch self {
      case .clear: "Clear"
      case .delete: "Delete"
      case .deleteForward: "Delete Forward"
      case .upArrow: "Up Arrow"
      case .downArrow: "Down Arrow"
      case .leftArrow: "Left Arrow"
      case .rightArrow: "Right Arrow"
      case .escape: "Escape"
      case .home: "Home"
      case .end: "End"
      case .pageUp: "Page Up"
      case .pageDown: "Page Down"
      case .`return`: "Return"
      case .space: "Space"
      case .tab: "Tab"
      case .init(character): "Character: \(character)"
      default: "Unknown"
    }
  }

  var symbolLiteral: Character {
    switch self {
      case .clear: "􀆄"
      case .delete: "􁂈"
      case .deleteForward: "􁂒"
      case .upArrow: "􀄤"
      case .downArrow: "􀄥"
      case .leftArrow: "􀄦"
      case .rightArrow: "􀰇"
      case .escape: "􀆧"
      case .home: "􀰹"
      case .end: "􀱈"
      case .pageUp: "􀅃"
      case .pageDown: "􀅄"
      case .`return`: "􀅇"
      case .space: "􁁺"
      case .tab: "􁂎"
      case .init(character): character
      default: "?"
    }
  }
  
  var symbolCapitalised: String {
    String(symbolLiteral).capitalized
  }

  var nameAndSymbol: String {
    switch self {
      case .clear, .delete, .deleteForward, .upArrow, .downArrow, .leftArrow, .rightArrow, .escape, .home, .end, .pageUp, .pageDown, .`return`, .space, .tab:
        "\(self.name) (\(self.symbolLiteral))"
        
      default:
        "\(self.name.capitalized)"
    }
  }

}

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

public extension EventModifiers {
  
//  var name: String {
//    switch self {
//      case .all: "All"
//      case .command: "Command"
//      case .option: "Option"
//      case .shift: "Shift"
//      case .control: "Control"
//      case .capsLock: "Caps Lock"
//      case .numericPad: "Numeric Pad"
//      default: "Unknown"
//    }
//  }
//
//  var symbolLiteral: Character {
//    switch self {
//      case .shift: "􀆝"
//      case .option: "􀆕"
//      case .command: "􀆔"
//      case .control: "􀆍"
//      case .capsLock: "􀆡"
//      default: "?"
//    }
//  }
  
//  var nameAndSymbol: String {
//    "\(self.name) (\(self.symbolLiteral))"
//  }


  struct ModifierSymbol {
    let name: String
    let symbol: Character
  }
  
  private var modifierSymbols: [(EventModifiers, ModifierSymbol)] {
    [
      (.control, .init(name: "Control", symbol: "􀆍")),
      (.shift, .init(name: "Shift", symbol: "􀆝")),
      (.option, .init(name: "Option", symbol: "􀆕")),
      (.command, .init(name: "Command", symbol: "􀆔")),
      (.capsLock, .init(name: "Caps Lock", symbol: "􀆡")),
//      (.numericPad, .init(name: "Numeric Pad", symbol: "􀅱")),
    ]
  }
  
  var activeModifiers: [ModifierSymbol] {
    modifierSymbols
      .filter { self.contains($0.0) }
      .map(\.1)
  }
  
  var names: String {
    activeModifiers.map(\.name).joined(separator: " + ")
  }
  
  var symbols: String {
    activeModifiers.map(\.symbol).map(String.init).joined()
  }
  
  var nameAndSymbol: String {
    let active = activeModifiers
    if active.isEmpty {
      return "None"
    }
    
    let names = active.map(\.name).joined(separator: " + ")
    let symbols = active.map(\.symbol).map(String.init).joined(separator: " + ")
    
    return "\(names) (\(symbols))"
  }
  
//  var nameAndSymbol: String {
//    let active = activeModifiers
//    if active.isEmpty {
//      return "None"
//    }
//    return active
//      .map { "\($0.name) (\($0.symbol))" }
//      .joined(separator: " + ")
//  }
}


//  enum Key: ShortcutKey, CaseIterable {
//    static public let allCases: [KBShortcut.Key] = [
//      .character("a"),
//      .clear,
//      .delete,
//      .deleteForward,
//      .upArrow,
//      .downArrow,
//      .leftArrow,
//      .rightArrow,
//      .escape,
//      .home,
//      .end,
//      .pageUp,
//      .pageDown,
//      .`return`,
//      .space,
//      .tab,
//    ]
//
//    case character(Character)
//    case clear
//    case delete
//    case deleteForward
//    case upArrow
//    case downArrow
//    case leftArrow
//    case rightArrow
//    case escape
//    case home
//    case end
//    case pageUp
//    case pageDown
//    case `return`
//    case space
//    case tab
//
//    public var name: String {
//      switch self {
//        case .character(let character): "\(character.lowercased())"
//        case .clear: "Clear"
//        case .delete: "Delete"
//        case .deleteForward: "Delete Forward"
//        case .upArrow: "Up Arrow"
//        case .downArrow: "Down Arrow"
//        case .leftArrow: "Left Arrow"
//        case .rightArrow: "Right Arrow"
//        case .escape: "Escape"
//        case .home: "Home"
//        case .end: "End"
//        case .pageUp: "Page Up"
//        case .pageDown: "Page Down"
//        case .`return`: "Return"
//        case .space: "Space"
//        case .tab: "Tab"
//
//      }
//    }
//
//    public var symbolName: String {
//      switch self {
//        case .character(let character): "\(character)"
//        case .clear: "xmark"
//        case .delete: "delete.backward"
//        case .deleteForward: "delete.forward"
//        case .upArrow: "arrowtriangle.up"
//        case .downArrow: "arrowtriangle.down"
//        case .leftArrow: "arrowtriangle.left"
//        case .rightArrow: "arrowtriangle.right"
//        case .escape: "escape"
//        case .home: "arrow.up.left"
//        case .end: "arrow.down.right"
//        case .pageUp: "arrow.up.to.line.compact"
//        case .pageDown: "arrow.down.to.line.compact"
//        case .`return`: "return"
//        case .space: "space"
//        case .tab: "arrow.forward.to.line"
//
//      }
//    }
//
//    public var symbolLiteral: Character {
//      switch self {
//        case .character(let character): character
//        case .clear: "􀆄"
//        case .delete: "􁂈"
//        case .deleteForward: "􁂒"
//        case .upArrow: "􀄤"
//        case .downArrow: "􀄥"
//        case .leftArrow: "􀄦"
//        case .rightArrow: "􀰇"
//        case .escape: "􀆧"
//        case .home: "􀰹"
//        case .end: "􀱈"
//        case .pageUp: "􀅃"
//        case .pageDown: "􀅄"
//        case .`return`: "􀅇"
//        case .space: "􁁺"
//        case .tab: "􁂎"
//      }
//    }
//
//    public var alternativeLiteral: Character? {
//      switch self {
//        case .upArrow: "↑"
//        case .downArrow: "↓"
//        case .leftArrow: "←"
//        case .rightArrow: "→"
//        default: nil
//      }
//    }
//
//    public var type: KBShortcut.KeyType {
//      .key
//    }
//
