//
//  MouseLock.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/5/2025.
//

import AppKit
import SwiftUI

public struct MouseLockModifier: ViewModifier {
  @Binding var isLocked: Bool
  let newPosition: CGPoint?

  public init(
    isLocked: Binding<Bool>,
    newPosition: CGPoint?
  ) {
    self._isLocked = isLocked
    self.newPosition = newPosition
  }

  public func body(content: Content) -> some View {
    content
      .task(id: isLocked) {
        Task { @MainActor in
          if isLocked {
            print("Mouse set to Locked 🔐")
//            NSCursor.hide()
            CGAssociateMouseAndMouseCursorPosition(0)  // Arrest pointer (0 = false)
          } else {
            print("Mouse set to Unlocked 🔓")
//            NSCursor.unhide()
//            if let newPosition {
//              CGWarpMouseCursorPosition(newPosition)
//            }
            CGAssociateMouseAndMouseCursorPosition(1)  // Release pointer (1 = true)
          }
        }
      }
  }
}
extension View {
  public func mouseLock(
    _ isLocked: Binding<Bool>,
    newPosition: CGPoint? = nil
  ) -> some View {
    self.modifier(
      MouseLockModifier(
        isLocked: isLocked,
        newPosition: newPosition
      )
    )
  }
}
