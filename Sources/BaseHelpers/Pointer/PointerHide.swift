//
//  PointerLock.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/5/2025.
//

#if canImport(AppKit)
import AppKit
import SwiftUI

import SwiftUI

//@Observable
//final public class PointerHideHandler {
//  public var isHidden: Bool = false {
//    didSet {
//      print("`isHidden` changed to \(isHidden)")
//      if oldValue != isHidden {
//        updateCursor()
//      }
//    }
//  }
//  
//  public init(isHidden: Bool = false) {
//    self.isHidden = isHidden
//  }
//  
//  private func updateCursor() {
//    if isHidden {
//      NSCursor.hide()
//      CGAssociateMouseAndMouseCursorPosition(0)
//    } else {
//      CGAssociateMouseAndMouseCursorPosition(1)
//      NSCursor.unhide()
//      NSCursor.arrow.set()
//    }
//  }
//}

public struct PointerHideModifier: ViewModifier {
  

  let isHidden: Bool

  public func body(content: Content) -> some View {
    content
//      .onChange(of: isHidden, initial: true) { oldValue, newValue in
//        if oldValue == true {
//          
//        }
//      }
      .task(id: isHidden) {
        print("`pointerHide()` Ran task")
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
extension PointerHideModifier {
//  private func
}
extension View {
  public func pointerHide(isHidden: Bool = true) -> some View {
    self.modifier(
      PointerHideModifier(isHidden: isHidden)
    )
  }
}
#endif
