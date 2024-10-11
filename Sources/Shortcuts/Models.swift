//
//  Models.swift
//  Helpers
//
//  Created by Dave Coleman on 8/9/2024.
//

#if canImport(AppKit)

import SwiftUI
import BaseHelpers

/// SwiftUI uses: `KeyboardShortcut`

// MARK: - Main Shortcut model
public struct KBShortcut: Equatable, Sendable {
  public let key: KBShortcut.Key
  public let modifiers: [KBShortcut.Modifier]
  public let label: KBShortcut.Label?
  
  public init(
    _ key: KBShortcut.Key,
    modifiers: [KBShortcut.Modifier] = [],
    label: Label? = nil
  ) {
    self.key = key
    self.modifiers = modifiers
    self.label = label
  }
  
  /// AppKit init
  public init(
    _ key: KBShortcut.Key,
    modifierFlags: NSEvent.ModifierFlags,
    label: KBShortcut.Label? = nil
  ) {
    self.key = key
    self.modifiers = KBShortcut.Modifier.from(modifierFlags)
    self.label = label
  }
}


extension KBShortcut {
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

public extension KBShortcut {
  
  enum KeyType {
    case key
    case modifier
  }
  
  protocol ShortcutKey: Equatable, Sendable {
    
    /// E.g. `Delete` or `Control`
    var name: String { get }
    
    /// E.g. `delete.backward` or `control`
    var symbolName: String { get }
    
    /// E.g. `􁂈` or `􀆍`
    var symbolLiteral: String { get }
    
    var type: KeyType { get }
  }

//  public var swiftUIShortcut: KeyboardShortcut {
//    KeyboardShortcut(KeyEquivalent(Character(self.key)), modifiers: modifiers)
//  }
//  
//  public var appKitModifiers: NSEvent.ModifierFlags {
//    modifiers.appKitModifiers
//  }
  
  
}

extension KBShortcut: CustomStringConvertible {
  
  public var description: String {
    
    let key = self.key.name.uppercased()
    let modifierLiterals = self.modifiers.summarise(key: \.symbolLiteral, delimiter: nil)
    let modifierNames = self.modifiers.summarise(key: \.symbolName)
    
    let result: String = """
    
    \(modifierLiterals)\(key)
    Shortcut(
      key: \(key), 
      modifiers: \(modifierNames)
    )
    """
    
    return result
  }
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
