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

//  let onDelta: (CGFloat, CGFloat) -> Void
  
  public init(
    isLocked: Binding<Bool>,
//    onDelta: @escaping (CGFloat, CGFloat) -> Void,
  ) {
    self._isLocked = isLocked
//    self.onDelta = onDelta
  }

  public func body(content: Content) -> some View {
    content
      .task(id: isLocked) {
        if isLocked {
//          NSCursor.unhide()
          NSCursor.hide()
          CGAssociateMouseAndMouseCursorPosition(0)  // Arrest pointer (0 = false)
        } else {
          NSCursor.unhide()
          CGAssociateMouseAndMouseCursorPosition(1)  // Release pointer (1 = true)
        }
      }
      
  }
}

extension MouseLockModifier {
  func handleLock(_ isLocked: Bool) -> Int32 {
    isLocked ? 0 : 1
  }
}

extension View {
  public func mouseLock(
    _ isLocked: Binding<Bool>
  ) -> some View {
    self.modifier(MouseLockModifier(isLocked: isLocked))
  }
}
