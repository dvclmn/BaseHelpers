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

public typealias Keys = Set<KeyEquivalent>
public typealias Modifiers = CompatibleModifierKeys

public struct CompatibleModifierKeys: OptionSet, Sendable, Hashable {
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
  public let rawValue: Int

  public static let capsLock = Self(rawValue: 1 << 0)
  public static let shift = Self(rawValue: 1 << 1)
  public static let control = Self(rawValue: 1 << 2)
  public static let option = Self(rawValue: 1 << 3)
  public static let command = Self(rawValue: 1 << 4)

}

extension CompatibleModifierKeys {
  public init(from appKitKey: NSEvent.ModifierFlags) {
    self = appKitKey.toCompatibleModifier
  }

  struct ModifierMetadata: Hashable {
    let name: String
    let symbol: String
  }

  private static let metadata: [CompatibleModifierKeys: ModifierMetadata] = [
    .shift: .init(name: "Shift", symbol: "􀆝"),
    .control: .init(name: "Control", symbol: "􀆍"),
    .option: .init(name: "Option", symbol: "􀆕"),
    .command: .init(name: "Command", symbol: "􀆔"),
    .capsLock: .init(name: "Caps Lock", symbol: "􀆡"),
  ]

  private var individualOptions: [CompatibleModifierKeys] {
    Self.metadata.keys.filter { contains($0) }
  }

  public func displayName(
    elements: ModifierDisplayElement,
    separator: String = " + ",
    emptyText: String = "None"
  ) -> String {
    let components: [String] = individualOptions.compactMap { option in
      guard let meta = Self.metadata[option] else { return nil }

      switch elements {
        case .name:
          return meta.name
        case .icon:
          return meta.symbol
        case .both:
          return "\(meta.symbol) \(meta.name)"
        default:
          return nil
      }
    }

    return components.isEmpty ? emptyText : components.joined(separator: separator)
  }

}

extension CompatibleModifierKeys: CustomStringConvertible {
  public var description: String { displayName(elements: .name) }
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

public struct ModifierDisplayElement: OptionSet, Sendable {
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
  public let rawValue: Int

  public static let name = Self(rawValue: 1 << 0)
  public static let icon = Self(rawValue: 1 << 1)
  public static let both: Self = [.name, .icon]
}

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
