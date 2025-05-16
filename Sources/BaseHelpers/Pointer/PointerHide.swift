//
//  PointerLock.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/5/2025.
//

#if canImport(AppKit)
import AppKit
import SwiftUI

public struct PointerHideModifier: ViewModifier {

  let isHidden: Bool

  public func body(content: Content) -> some View {
    content
      .task(id: isHidden) {
        Task { @MainActor in
          if isHidden {
            print("Mouse set to Hidden")
            NSCursor.hide()
            /// Arresting the mouse too, so it doesn't cause mischief whilst hidden
            CGAssociateMouseAndMouseCursorPosition(0)

          } else {
            print("Mouse set to Showing")

            /// Releasing the mouse, just in case
            CGAssociateMouseAndMouseCursorPosition(1)
            NSCursor.unhide()
            NSCursor.arrow.set()
          }
        }
      }
  }
}
extension View {
  public func pointerHide(isHidden: Bool = true) -> some View {
    self.modifier(
      PointerHideModifier(isHidden: isHidden)
    )
  }
}
#endif
