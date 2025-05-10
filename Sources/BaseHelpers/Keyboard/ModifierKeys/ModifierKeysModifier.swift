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

    #if canImport(AppKit)
    content
      .onAppear {
        let modifierList: [NSEvent.ModifierFlags] = [.shift, .control, .option, .command]
        print("Setting up modifier keys.")
        NSEvent.addLocalMonitorForEvents(matching: [.flagsChanged]) { event in
          modifierKeys = Set(
            modifierList.compactMap { flag in
              event.modifierFlags.contains(flag) ? flag.toModifierKey() : nil
            })
          return event
        }
      }
      .environment(\.modifierKeys, modifierKeys)
    #else
    content
    #endif

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
