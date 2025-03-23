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

public typealias Modifiers = Set<ModifierKey>

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

extension EnvironmentValues {
  @Entry public var modifierKeys: Modifiers = .init()
}

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

public struct ModifierKeysModifier: ViewModifier {

  @State private var modifierKeys = Modifiers()
  #if canImport(AppKit)
    private let allModifiers: [NSEvent.ModifierFlags] = [.shift, .control, .option, .command]
  #endif
  public func body(content: Content) -> some View {

    #if canImport(AppKit)
      content
        .onAppear {
          print("Setting up modifier keys.")
          NSEvent.addLocalMonitorForEvents(matching: [.flagsChanged]) { event in
            modifierKeys = Set(
              allModifiers.compactMap { flag in
                event.modifierFlags.contains(flag) ? flag.toModifierKey() : nil
              })
            return event
          }
        }
        .environment(\.modifierKeys, modifierKeys)
//        .task(id: modifierKeys) {
//          print("Modifier key(s) changed: \(modifierKeys)")
//        }
    #else
      content
    #endif

  }
}

//#endif

extension View {
  #if canImport(AppKit)
    public func readModifierKeys() -> some View {
      self.modifier(ModifierKeysModifier())
    }
  #elseif canImport(UIKit)
    public func readModifierKeys() -> some View {
      self
    }
  #endif
}
