//
//  MouseLock.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/5/2025.
//

import AppKit
import SwiftUI

public struct MouseLockModifier: ViewModifier {

  let isLocked: Bool
//  let shouldHide: Bool
  let newPosition: CGPoint?

  public func body(content: Content) -> some View {
    content
      .task(id: isLocked) {
        Task { @MainActor in
          if isLocked {
            /// Arrest pointer (0 = false)
            CGAssociateMouseAndMouseCursorPosition(0)
          } else {
            /// Release pointer (1 = true)
            CGAssociateMouseAndMouseCursorPosition(1)
            if let newPosition {
              CGWarpMouseCursorPosition(newPosition)
            }
          }
        }
      }
//      .mouseHide(isHidden: shouldHide)
  }
}
extension View {
  public func mouseLock(
    _ isLocked: Bool,
//    shouldHide: Bool = true,
    newPosition: CGPoint? = nil
  ) -> some View {
    self.modifier(
      MouseLockModifier(
        isLocked: isLocked,
//        shouldHide: shouldHide,
        newPosition: newPosition
      )
    )
  }
}
