//
//  Models.swift
//  Helpers
//
//  Created by Dave Coleman on 8/9/2024.
//

#if canImport(AppKit)

import SwiftUI

@MainActor
public struct Keyboard: Sendable, Equatable {
  
  public struct Shortcut: Equatable {
    public let key: Keyboard.Key
    public let modifiers: [Keyboard.Modifier]
    public let label: Label?
    
    public init(
      _ key: Keyboard.Key,
      modifiers: [Keyboard.Modifier] = [],
      label: Label? = nil
    ) {
      self.key = key
      self.modifiers = modifiers
      self.label = label
    }
    
    public init(
      _ key: Keyboard.Key,
      modifierFlags: NSEvent.ModifierFlags,
      label: Label? = nil
    ) {
      self.key = key
      self.modifiers = Keyboard.Modifier.from(modifierFlags)
      self.label = label
    }
  }
}

extension Keyboard.Shortcut {
  
  public struct Label: Equatable, Sendable {
    public var title: String
    public var icon: String
    
    public init(
      title: String,
      icon: String
    ) {
      self.title = title
      self.icon = icon
    }
  }
}

extension Keyboard {

  public enum KeyType {
    case key
    case modifier
  }

  public protocol ShortcutKey: Equatable {
    
    /// E.g. `Delete` or `Control`
    var name: String { get }
    
    /// E.g. `delete.backward` or `control`
    var symbolName: String { get }
    
    /// E.g. `􁂈` or `􀆍`
    var symbolLiteral: String { get }
    
    var type: KeyType { get }
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

#endif
