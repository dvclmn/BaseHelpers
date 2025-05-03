//
//  MouseLock.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/5/2025.
//

import AppKit
import SwiftUI

public struct MouseLockModifier: ViewModifier {
  @State private var monitor: Any?
  @Binding var isLocked: Bool

  let onDelta: (CGFloat, CGFloat) -> Void
  
  public init(
    isLocked: Binding<Bool>,
    onDelta: @escaping (CGFloat, CGFloat) -> Void,
  ) {
    self._isLocked = isLocked
    self.onDelta = onDelta
  }

  public func body(content: Content) -> some View {
    content
      .onAppear {
//        if !isLocked {
//          NSCursor.hide()
//          CGAssociateMouseAndMouseCursorPosition(0)  // Arrest pointer (0 = false)
//          isLocked = true
//        }

        monitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved, .leftMouseDragged, .otherMouseDragged]) {
          event in
          onDelta(event.deltaX, event.deltaY)
          return nil  // consume the event
        }
      }
      .onDisappear {
        if isLocked {
          NSCursor.unhide()
          CGAssociateMouseAndMouseCursorPosition(1)  // Release pointer (1 = true)
          isLocked = false
        }

        if let m = monitor {
          NSEvent.removeMonitor(m)
          monitor = nil
        }
      }
  }
}

extension View {
  public func mouseLock(
    _ isLocked: Binding<Bool>,
    onDelta: @escaping (CGFloat, CGFloat) -> Void
  ) -> some View {
    self.modifier(MouseLockModifier(isLocked: isLocked, onDelta: onDelta))
  }
}
