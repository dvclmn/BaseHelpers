//
//  Models+Modifier.swift
//  Helpers
//
//  Created by Dave Coleman on 8/9/2024.
//

import SwiftUI

#if canImport(AppKit)

extension KBShortcut {
  
  public enum Modifier: ShortcutKey, CaseIterable {
    
    case shift
    case option
    case command
    case control
    case capsLock
    
    public var name: String {
      self.symbolName
    }
    
    public var symbolName: String {
      switch self {
        case .shift: "shift"
        case .option: "option"
        case .command: "command"
        case .control: "control"
        case .capsLock: "capslock"
      }
    }
    
    public var symbolLiteral: Character {
      switch self {
        case .shift: "􀆝"
        case .option: "􀆕"
        case .command: "􀆔"
        case .control: "􀆍"
        case .capsLock: "􀆡"
      }
    }
    
    public var type: KBShortcut.KeyType {
      .modifier
    }
    
    public var appKit: NSEvent.ModifierFlags {
      switch self {
        case .shift: .shift
        case .option: .option
        case .command: .command
        case .control: .control
        case .capsLock: .capsLock
      }
    }
    
    public var swiftUI: EventModifiers {
      switch self {
        case .shift: .shift
        case .option: .option
        case .command: .command
        case .control: .control
        case .capsLock: .capsLock
      }
    }
    
    static func from(_ modifierFlags: NSEvent.ModifierFlags) -> [Modifier] {
      var modifiers: [Modifier] = []
      if modifierFlags.contains(.command) { modifiers.append(.command) }
      if modifierFlags.contains(.option) { modifiers.append(.option) }
      if modifierFlags.contains(.control) { modifiers.append(.control) }
      if modifierFlags.contains(.shift) { modifiers.append(.shift) }
      if modifierFlags.contains(.capsLock) { modifiers.append(.capsLock) }
      return modifiers
    }
    
  }
}
#endif
