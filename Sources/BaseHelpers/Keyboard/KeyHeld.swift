//
//  KeyHeld.swift
//  Collection
//
//  Created by Dave Coleman on 6/12/2024.
//

import SwiftUI

public struct KeyHeldModifier: ViewModifier {
  let key: KeyEquivalent
  @State private var keyDownMonitor: Any?
  @State private var keyUpMonitor: Any?
  let isHeld: (Bool) -> Void
  let onPress: () -> Void
  
  public func body(content: Content) -> some View {
    content
      .onAppear {
        keyDownMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
          if event.characters == String(key.character) {
            isHeld(true)
            onPress()
            return nil
          } else {
            return event
          }
        }
        
        keyUpMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyUp) { event in
          if event.characters == String(key.character) {
            isHeld(false)
            return nil
          } else {
            return event
          }
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
  func keyHeld(
    _ key: KeyEquivalent,
    isHeld: @escaping (Bool) -> Void
  ) -> some View {
    self.modifier(
      KeyHeldModifier(
        key: key,
        isHeld: isHeld,
        onPress: {}
      )
    )
  }
  
  func keyPressed(
    _ key: KeyEquivalent,
    onPress: @escaping () -> Void
  ) -> some View {
    self.modifier(
      KeyHeldModifier(
        key: key,
        isHeld: { _ in },
        onPress: onPress
      )
    )
  }
}




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
