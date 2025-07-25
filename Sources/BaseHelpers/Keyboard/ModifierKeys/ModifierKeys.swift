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
  @Entry public var modifierKeys: Modifiers = []
}

public typealias Modifiers = CompatibleModifierKeys

public struct CompatibleModifierKeys: OptionSet, Sendable {
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
  public let rawValue: Int

  public static let capsLock = Self(rawValue: 1 << 0)
  public static let shift = Self(rawValue: 1 << 1)
  public static let control = Self(rawValue: 1 << 2)
  public static let option = Self(rawValue: 1 << 3)
  public static let command = Self(rawValue: 1 << 4)

  public var displayNames: [String] {
    var names: [String] = []
    if contains(.capsLock) { names.append("Caps Lock") }
    if contains(.shift) { names.append("Shift") }
    if contains(.control) { names.append("Control") }
    if contains(.option) { names.append("Option") }
    if contains(.command) { names.append("Command") }
    return names
  }

  public var displayName: String {
    let names = displayNames
    return names.isEmpty ? "None" : names.joined(separator: " + ")
  }

  //  public var displayName: String {
  //    switch self {
  //      case .shift: "Shift"
  //      case .control: "Control"
  //      case .option: "Option"
  //      case .command: "Command"
  //      case .capsLock: "Caps Lock"
  //      default: "Unknown"
  //    }
  //  }
}

extension CompatibleModifierKeys {
  public init(from appKitKey: NSEvent.ModifierFlags) {
    self = appKitKey.toCompatibleModifier
  }

  public var symbol: String {
    switch self {
      case .shift: "􀆝"
      case .control: "􀆍"
      case .option: "􀆕"
      case .command: "􀆔"
      case .capsLock: "􀆡"
      default:
        ""
    }
  }
}

extension CompatibleModifierKeys: CustomStringConvertible {
  public var description: String { displayName }
}

@available(macOS 15, iOS 18, *)
extension CompatibleModifierKeys {
  public init(from swiftUIKey: EventModifiers) {
    self = swiftUIKey.toCompatibleModifier
  }
}

@available(macOS 15, iOS 18, *)
extension EventModifiers {

  public static var defaultKeys: Self {
    [.command, .shift, .option, .control, .capsLock]
  }

  public var toCompatibleModifier: CompatibleModifierKeys {
    switch self {
      case .shift: return .shift
      case .control: return .control
      case .option: return .option
      case .command: return .command
      case .capsLock: return .capsLock
      default: return []
    }
  }
}

#if canImport(AppKit)
extension NSEvent.ModifierFlags {
  public var toCompatibleModifier: CompatibleModifierKeys {
    switch self {
      case .shift: return .shift
      case .control: return .control
      case .option: return .option
      case .command: return .command
      case .capsLock: return .capsLock
      default: return []
    }
  }
}
#endif

//public enum CompatibleModifierKey: String, CaseIterable, Identifiable, Hashable, Sendable {
//  case command
//  case shift
//  case option
//  case control
//  case capsLock
//
//  public var id: String { self.rawValue }
//
//  public var name: String {
//    switch self {
//      case .command: "Command"
//      case .shift: "Shift"
//      case .option: "Option"
//      case .control: "Control"
//      case .capsLock: "Caps Lock"
//    }
//  }
//
//  public var symbol: String {
//    switch self {
//      case .shift: "􀆝"
//      case .control: "􀆍"
//      case .option: "􀆕"
//      case .command: "􀆔"
//      case .capsLock: "􀆡"
//    }
//  }
//}

//extension Modifiers {
//  public var names: String? {
//    guard !self.isEmpty else {
//      return nil
//    }
//    return self.map(\.name).joined()
//  }
//
//  public var symbols: String? {
//    guard !self.isEmpty else {
//      return nil
//    }
//    return self.map(\.symbol).joined()
//  }
//}

//#if os(macOS)
