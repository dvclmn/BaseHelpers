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

@Observable
final class PointerHandler {
  var pointerStyle: NSCursor = .current
  //  var isWatchingHover: Bool = false
  var isHovering: Bool = false

  init(
    pointerStyle: NSCursor
  ) {
    self.pointerStyle = pointerStyle
  }
}


public struct PointerHoverChangeModifier: ViewModifier {

  @State private var pointerHandler: PointerHandler
  //  @State private var isHovering: Bool = false

  //  let pointerStyle: NSCursor

  public init(
    pointerStyle: NSCursor
  ) {
    self._pointerHandler = State(initialValue: PointerHandler(pointerStyle: pointerStyle))
    self.pointerHandler = pointerHandler
  }

  public func body(content: Content) -> some View {
    content
      .onHover { hover in
        //        if pointerHandler.isWatchingHover {
        pointerHandler.isHovering = hover
        //        }

        DispatchQueue.main.async {
          if pointerHandler.isHovering {
            // See https://stackoverflow.com/a/62984079/7964697 for details.
            NSApp.windows.forEach { $0.disableCursorRects() }
            pointerHandler.pointerStyle.push()

          } else {
            NSCursor.pop()
            NSApp.windows.forEach { $0.enableCursorRects() }
          }
        }
      }
  }
}
extension View {
  public func pointerChangeOnHover(to style: NSCursor) -> some View {
    self.modifier(
      PointerHoverChangeModifier(pointerStyle: style)
    )
  }
}

public struct PointerChangeModifier: ViewModifier {

  let pointerStyle: NSCursor?

  public func body(content: Content) -> some View {
    content
      .task(id: pointerStyle) {
        DispatchQueue.main.async {
          if let pointerStyle {
            // See https://stackoverflow.com/a/62984079/7964697 for details.
            NSApp.windows.forEach { $0.disableCursorRects() }
            pointerStyle.push()

          } else {
            NSCursor.pop()
            NSApp.windows.forEach { $0.enableCursorRects() }
          }
        }
      }

  }
}
extension View {
  public func pointerChangeOnHover(to style: NSCursor?) -> some View {
    self.modifier(
      PointerChangeModifier(pointerStyle: style)
    )
  }
}
#endif
