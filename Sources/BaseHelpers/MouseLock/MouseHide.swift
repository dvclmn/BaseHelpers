//
//  MouseLock.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/5/2025.
//

import AppKit
import SwiftUI

public struct MouseHideModifier: ViewModifier {

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
  public func mouseHide(isHidden: Bool = true) -> some View {
    self.modifier(
      MouseHideModifier(isHidden: isHidden)
    )
  }
}
