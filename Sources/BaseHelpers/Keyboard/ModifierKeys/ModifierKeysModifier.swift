//
//  Untitled.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/5/2025.
//

import SwiftUI

public struct ModifierKeysModifier: ViewModifier {

  @State private var modifierKeys = Modifiers()

  public func body(content: Content) -> some View {

    if #available(macOS 15, iOS 18, *) {
      content
        .onModifierKeysChanged(mask: .defaultKeys, initial: true) { old, new in
          self.modifierKeys = Modifiers(from: new)
        }
        .environment(\.modifierKeys, modifierKeys)

    } else {
      #if canImport(AppKit)
      content
        .onAppear {
          NSEvent.addLocalMonitorForEvents(matching: [.flagsChanged]) { event in
            self.modifierKeys = Modifiers(from: event.modifierFlags)
            return event
          }
        }
        .environment(\.modifierKeys, modifierKeys)
      #else
      content
      #endif
    }

  }
}

extension View {
  public func readModifierKeys() -> some View {
    #if canImport(AppKit)
    self.modifier(ModifierKeysModifier())
    #elseif canImport(UIKit)
    self
    #endif
  }
}
