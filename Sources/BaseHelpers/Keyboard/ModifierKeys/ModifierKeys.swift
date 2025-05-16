//
//  File.swift
//
//
//  Created by Dave Coleman on 23/7/2024.
//

import Foundation
import SwiftUI

/// Important: Don't forget to provide the entry point for the modifier:
///
/// ```
/// import SwiftUI
/// import BaseHelpers // <- Import this
///
/// @main
/// struct ExampleApp: App {
///
///   var body: some Scene {
///     WindowGroup {
///       ContentView()
///         .readModifierKeys() // <- Here
///     }
///   }
/// }
/// ```

extension EnvironmentValues {
  @Entry public var modifierKeys: Modifiers = .init()
}

extension Set where Element == ModifierKey {
  
  public func containsOnly(_ key: ModifierKey) -> Bool {
    return self.contains(where: { $0 == key})
  }
}


public typealias Modifiers = Set<ModifierKey>

extension ModifierKey: CustomStringConvertible {
  public var description: String { self.name }
}

public enum ModifierKey: String, CaseIterable, Identifiable, Hashable, Sendable {
  case command
  case shift
  case option
  case control

  public var id: String { self.rawValue }
  public var name: String { self.rawValue.capitalized }

  public var symbol: String {
    switch self {
      case .shift: "􀆝"
      case .control: "􀆍"
      case .option: "􀆕"
      case .command: "􀆔"
    }
  }
}

extension Modifiers {
  public var names: String? {
    guard !self.isEmpty else {
      return nil
    }
    return self.map(\.name).joined()
  }

  public var symbols: String? {
    guard !self.isEmpty else {
      return nil
    }
    return self.map(\.symbol).joined()
  }
}

//#if os(macOS)


#if canImport(AppKit)
  extension NSEvent.ModifierFlags {
    public func toModifierKey() -> ModifierKey? {
      switch self {
        case .shift: return .shift
        case .control: return .control
        case .option: return .option
        case .command: return .command
        default: return nil
      }
    }
  }
#endif

