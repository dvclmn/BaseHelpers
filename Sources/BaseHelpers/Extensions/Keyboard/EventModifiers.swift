//
//  KeyEquivalent.swift
//  Collection
//
//  Created by Dave Coleman on 23/12/2024.
//

import SwiftUI

extension EventModifiers {

  public struct ModifierSymbol {
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
      (.numericPad, .init(name: "Numeric Pad", symbol: "􀅱")),
    ]
  }

  public var activeModifiers: [ModifierSymbol] {
    modifierSymbols
      .filter { self.contains($0.0) }
      .map(\.1)
  }

  public var names: String {
    activeModifiers.map(\.name).joined(separator: " + ")
  }

  public var symbols: String {
    activeModifiers.map(\.symbol).map(String.init).joined()
  }

  public var nameAndSymbol: String {
    let active = activeModifiers
    if active.isEmpty {
      return "None"
    }

    let names = active.map(\.name).joined(separator: " + ")
    let symbols = active.map(\.symbol).map(String.init).joined(separator: " + ")

    return "\(names) (\(symbols))"
  }

}
