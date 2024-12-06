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
  
  public func body(content: Content) -> some View {
    content
      .onAppear {
        keyDownMonitor = NSEvent
          .addLocalMonitorForEvents(matching: .keyDown) { event in
            self.isHeld(event.)
            return event
          }
      }
      .onDisappear {
        if let down = keyDownMonitor {
          NSEvent.removeMonitor(down)
        }
      }
  }
}

extension View {
  public func keyHeld(
    _ key: KeyEquivalent,
    isHeld: @escaping (Bool) -> Void
  ) -> some View {
    self.modifier(
      KeyHeldModifier(
        key: key,
        isHeld: isHeld
      )
    )
  }
}
