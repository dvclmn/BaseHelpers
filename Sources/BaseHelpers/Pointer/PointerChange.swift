//
//  PointerLock.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/5/2025.
//

#if canImport(AppKit)
import AppKit
import SwiftUI


  



public struct PointerChangeModifier: ViewModifier {
  @State private var isHovering: Bool = false
//  let isLocked: Bool
//  let shouldHide: Bool
//  let newPosition: CGPoint?

  let pointerStyle: NSCursor
  
  public func body(content: Content) -> some View {
    content
      .onHover { hover in
        self.isHovering = hover
        DispatchQueue.main.async {
          if self.isHovering {
            /// Looks like ugly hack, but otherwise cursor gets reset to standard arrow.
            // See https://stackoverflow.com/a/62984079/7964697 for details.
            NSApp.windows.forEach { $0.disableCursorRects() }
            
            // swiftlint:disable:next force_unwrapping
            pointerStyle.push()
//            NSCursor(image: NSImage(named: "ZoomPlus")!, hotSpot: NSPoint(x: 9, y: 9)).push() // Cannot be nil.
          } else {
            NSCursor.pop()
            NSApp.windows.forEach { $0.enableCursorRects() }
          }
        }
      }

//      .task(id: isLocked) {
//        Task { @MainActor in
//          
//          NSCursor.closedHand.
////          if isLocked {
////            /// Arrest pointer (0 = false)
//////            CGAssociateMouseAndMouseCursorPosition(0)
////          } else {
////            /// Release pointer (1 = true)
////            CGAssociateMouseAndMouseCursorPosition(1)
////            if let newPosition {
////              CGWarpMouseCursorPosition(newPosition)
////            }
////          }
//        }
//      }
//      .pointerHide(isHidden: shouldHide)
  }
}
extension View {
  public func pointerChange(to style: NSCursor) -> some View {
    self.modifier(
      PointerChangeModifier(pointerStyle: style)
    )
  }
}
#endif
