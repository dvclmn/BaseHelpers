//
//  File.swift
//
//
//  Created by Dave Coleman on 11/8/2024.
//

import Foundation
import SwiftUI

@MainActor
public struct Keyboard: Sendable {
  public struct Shortcut {
    public let key: String
    public let modifiers: Modifiers
    public let doesRequireSelection: Bool
    
    
    public init(
      _ key: String,
      modifiers: Modifiers = [],
      doesRequireSelection: Bool = false
    ) {
      self.key = key
      self.modifiers = modifiers
      self.doesRequireSelection = doesRequireSelection
    }
    
    public var description: String {
      
      let modifierResult: String = self.modifiers.
      
      return "Shortcut(key: \(self.key), modifiers"
    }
    
    public var swiftUIShortcut: KeyboardShortcut {
      KeyboardShortcut(KeyEquivalent(Character(key)), modifiers: modifiers.swiftUIModifiers)
    }
    
    public var appKitModifiers: NSEvent.ModifierFlags {
      modifiers.appKitModifiers
    }
    
  }
  
  public struct Modifiers: OptionSet, Sendable {
    public let rawValue: Int
    
    public init(rawValue: Int) {
      self.rawValue = rawValue
    }
    
    public static let command = Modifiers(rawValue: 1 << 0)
    public static let option = Modifiers(rawValue: 1 << 1)
    public static let control = Modifiers(rawValue: 1 << 2)
    public static let shift = Modifiers(rawValue: 1 << 3)
    
    
    var swiftUIModifiers: SwiftUI.EventModifiers {
      var modifiers: SwiftUI.EventModifiers = []
      if contains(.command) { modifiers.insert(.command) }
      if contains(.option) { modifiers.insert(.option) }
      if contains(.control) { modifiers.insert(.control) }
      if contains(.shift) { modifiers.insert(.shift) }
      return modifiers
    }
    
    var appKitModifiers: NSEvent.ModifierFlags {
      var modifiers: NSEvent.ModifierFlags = []
      if contains(.command) { modifiers.insert(.command) }
      if contains(.option) { modifiers.insert(.option) }
      if contains(.control) { modifiers.insert(.control) }
      if contains(.shift) { modifiers.insert(.shift) }
      return modifiers
    }
    
  }
}
