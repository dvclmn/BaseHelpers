//
//  Models.swift
//  Helpers
//
//  Created by Dave Coleman on 8/9/2024.
//


import SwiftUI



@MainActor
public struct Keyboard: Sendable {
  
  public struct Shortcut {
    public let key: Keyboard.Key
    public let modifiers: [Modifier]
    public let requiresTextSelection: Bool
    
    
    public init(
      _ key: Keyboard.Key,
      modifiers: [Modifier] = [],
      requiresTextSelection: Bool = false
    ) {
      self.key = key
      self.modifiers = modifiers
      self.requiresTextSelection = requiresTextSelection
    }
  }
}


extension Keyboard {

  public enum KeyType {
    case key
    case modifier
  }

  public protocol ShortcutKey {
    
    /// E.g. `Delete` or `Control`
    var name: String { get }
    
    /// E.g. `delete.backward` or `control`
    var symbolName: String { get }
    
    /// E.g. `􁂈` or `􀆍`
    var symbolLiteral: String { get }
    
    var type: KeyType { get }
  }
}


extension Keyboard {
  
  public struct Key: ShortcutKey {
    
    public let name: String
    public let symbolName: String
    public let symbolLiteral: String
    public let type: Keyboard.KeyType
    
    public init(
      name: String,
      symbolName: String,
      symbolLiteral: String,
      type: Keyboard.KeyType
    ) {
      self.name = name
      self.symbolName = symbolName
      self.symbolLiteral = symbolLiteral
      self.type = type
    }
    
  }
  
  public enum Modifier: ShortcutKey {
    
    case shift, option, command, control, capsLock
    
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
    
    public var symbolLiteral: String {
      switch self {
        case .shift: "􀆝"
        case .option: "􀆕"
        case .command: "􀆔"
        case .control: "􀆍"
        case .capsLock: "􀆡"
      }
    }
    
    public var type: Keyboard.KeyType {
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
    
  }
  
//  public var description: String {
//    
//    let modifierResult: String = self.modifiers.
//    
//    return "Shortcut(key: \(self.key), modifiers"
//  }
//  
//  public var swiftUIShortcut: KeyboardShortcut {
//    KeyboardShortcut(KeyEquivalent(Character(key)), modifiers: modifiers.swiftUIModifiers)
//  }
//  
//  public var appKitModifiers: NSEvent.ModifierFlags {
//    modifiers.appKitModifiers
//  }
//
  
}


//extension Keyboard {
//  
//  public struct Modifiers: OptionSet, Sendable {
//    public let rawValue: Int
//    
//    public init(rawValue: Int) {
//      self.rawValue = rawValue
//    }
//    
//    public static let command = Modifiers(rawValue: 1 << 0)
//    public static let option = Modifiers(rawValue: 1 << 1)
//    public static let control = Modifiers(rawValue: 1 << 2)
//    public static let shift = Modifiers(rawValue: 1 << 3)
//    
//    
//    var swiftUIModifiers: SwiftUI.EventModifiers {
//      var modifiers: SwiftUI.EventModifiers = []
//      if contains(.command) { modifiers.insert(.command) }
//      if contains(.option) { modifiers.insert(.option) }
//      if contains(.control) { modifiers.insert(.control) }
//      if contains(.shift) { modifiers.insert(.shift) }
//      return modifiers
//    }
//    
//    var appKitModifiers: NSEvent.ModifierFlags {
//      var modifiers: NSEvent.ModifierFlags = []
//      if contains(.command) { modifiers.insert(.command) }
//      if contains(.option) { modifiers.insert(.option) }
//      if contains(.control) { modifiers.insert(.control) }
//      if contains(.shift) { modifiers.insert(.shift) }
//      return modifiers
//    }
//    
//  }
//  
//}
