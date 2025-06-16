//
//  PointerLock.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/5/2025.
//

#if canImport(AppKit)
import AppKit
import SwiftUI

public struct PointerLockModifier: ViewModifier {

  let isLocked: Bool
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
//      .pointerHide(isHidden: shouldHide)
  }
}
extension View {
  public func pointerLock(
    _ isLocked: Bool,
//    shouldHide: Bool = true,
    newPosition: CGPoint? = nil
  ) -> some View {
    self.modifier(
      PointerLockModifier(
        isLocked: isLocked,
//        shouldHide: shouldHide,
        newPosition: newPosition
      )
    )
  }
}
#endif
