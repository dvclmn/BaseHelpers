//
//  KeyHeld.swift
//  Collection
//
//  Created by Dave Coleman on 6/12/2024.
//
#if canImport(AppKit)

import SwiftUI

public struct KeysPressedModifier: ViewModifier {
  
  @State private var keyDownMonitor: Any?
  @State private var keyUpMonitor: Any?
  @State private var heldKeys: Set<KeyEquivalent> = []

  let keys: Set<KeyEquivalent>
  let onPress: (KeyEquivalent) -> Void
  let isHeld: (KeyEquivalent, Bool) -> Void
  
  public func body(content: Content) -> some View {
    content
      .onAppear {
        keyDownMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
          guard let character = event.characters?.lowercased().first,
                let key = keys.first(where: { $0.character == character }) else {
            return event
          }
          
          if !heldKeys.contains(key) {
            heldKeys.insert(key)
            isHeld(key, true)
            onPress(key)
          }
          
          return nil
        }
        
        keyUpMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyUp) { event in
          guard let character = event.characters?.lowercased().first,
                let key = keys.first(where: { $0.character == character }) else {
            return event
          }
          
          heldKeys.remove(key)
          isHeld(key, false)
          return nil

        }
      }
      .onDisappear {
        if let down = keyDownMonitor {
          NSEvent.removeMonitor(down)
        }
        if let up = keyUpMonitor {
          NSEvent.removeMonitor(up)
        }
      }
  }
}

// Usage example:
public extension View {
  func keysPressed(
    _ keys: Set<KeyEquivalent>,
    onPress: @escaping (KeyEquivalent) -> Void
  ) -> some View {
    self.modifier(
      KeysPressedModifier(
        keys: keys,
        onPress: onPress,
        isHeld: { _, _ in }
      )
    )
  }
  
  func keysHeld(
    _ keys: Set<KeyEquivalent>,
    isHeld: @escaping (KeyEquivalent, Bool) -> Void,
    onPress: @escaping (KeyEquivalent) -> Void = { _ in }
  ) -> some View {
    self.modifier(
      KeysPressedModifier(
        keys: keys,
        onPress: onPress,
        isHeld: isHeld
      )
    )
  }

}

#endif
