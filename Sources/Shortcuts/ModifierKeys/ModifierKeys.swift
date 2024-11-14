//
//  File.swift
//
//
//  Created by Dave Coleman on 23/7/2024.
//

import Foundation
import SwiftUI

public typealias Modifiers = Set<ModifierKey>

public enum ModifierKey: Hashable, Sendable {
  case shift, control, option, command
}

#if os(macOS)



public extension NSEvent.ModifierFlags {
  func toModifierKey() -> ModifierKey? {
    switch self {
      case .shift: return .shift
      case .control: return .control
      case .option: return .option
      case .command: return .command
      default: return nil
    }
  }
}


public struct ModifierFlagsKey: EnvironmentKey {
  public static let defaultValue = Modifiers()
}

public extension EnvironmentValues {
  var modifierKeys: Modifiers {
    get { self[ModifierFlagsKey.self] }
    set { self[ModifierFlagsKey.self] = newValue }
  }
}



public struct ModifierKeysModifier: ViewModifier {
  @State private var modifierKeys = Modifiers()
  
  private let allModifiers: [NSEvent.ModifierFlags] = [.shift, .control, .option, .command]
  
  public func body(content: Content) -> some View {
    content
      .onAppear {
        NSEvent.addLocalMonitorForEvents(matching: [.flagsChanged]) { event in
          modifierKeys = Set(allModifiers.compactMap { flag in
            event.modifierFlags.contains(flag) ? flag.toModifierKey() : nil
          })
          return event
        }
      }
      .environment(\.modifierKeys, modifierKeys)
  }
}

#endif

public extension View {
#if canImport(AppKit)
  func readModifierKeys() -> some View {
    self.modifier(ModifierKeysModifier())
  }
#elseif canImport(UIKit)
  func readModifierKeys() -> some View {
    self
  }
  #endif
}

