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
//  @State private var isKeyCurrentlyPressed: Bool = false
  @State private var heldKeys: Set<KeyEquivalent> = []

//  let key: KeyEquivalent
//  let isHeld: (Bool) -> Void
//  let onPress: () -> Void
  
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
          
//          if event.characters == String(key.character) {
//            /// Only process if the key isn't already being held down
//            if !isKeyCurrentlyPressed {
//              isKeyCurrentlyPressed = true
//              isHeld(true)
//              onPress()
//            }
//            return nil
//          } else {
//            return event
//          }
        }
        
        keyUpMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyUp) { event in
          guard let character = event.characters?.lowercased().first,
                let key = keys.first(where: { $0.character == character }) else {
            return event
          }
          
          heldKeys.remove(key)
          isHeld(key, false)
          return nil
          
//          if event.characters == String(key.character) {
//            isKeyCurrentlyPressed = false
//            isHeld(false)
//            return nil
//          } else {
//            return event
//          }
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
//  func keyHeld(
//    _ key: KeyEquivalent,
//    isHeld: @escaping (Bool) -> Void
//  ) -> some View {
//    self.modifier(
//      KeyHeldModifier(
//        key: key,
//        isHeld: isHeld,
//        onPress: {}
//      )
//    )
//  }
//  
//  func keyPressed(
//    _ key: KeyEquivalent,
//    onPress: @escaping () -> Void
//  ) -> some View {
//    self.modifier(
//      KeyHeldModifier(
//        key: key,
//        isHeld: { _ in },
//        onPress: onPress
//      )
//    )
//  }
}

#endif


// You might also want to add a global monitor version for when the window isn't focused
//public struct KeyHeldGlobalModifier: ViewModifier {
//  let key: KeyEquivalent
//  @State private var keyDownMonitor: Any?
//  @State private var keyUpMonitor: Any?
//  let isHeld: (Bool) -> Void
//  
//  public func body(content: Content) -> some View {
//    content
//      .onAppear {
//        keyDownMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
//          if event.characters == String(key.character) {
//            isHeld(true)
//          }
//        }
//        
//        keyUpMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyUp) { event in
//          if event.characters == String(key.character) {
//            isHeld(false)
//          }
//        }
//      }
//      .onDisappear {
//        if let down = keyDownMonitor {
//          NSEvent.removeMonitor(down)
//        }
//        if let up = keyUpMonitor {
//          NSEvent.removeMonitor(up)
//        }
//      }
//  }
//}
