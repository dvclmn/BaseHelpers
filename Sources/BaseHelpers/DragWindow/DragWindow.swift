//
//  DragWindow.swift
//
//
//  Created by Dave Coleman on 8/6/2024.
//

#if os(macOS)

import Foundation
import SwiftUI

/// Allows this view, when clicked and dragged, to move the whole Window.
public struct DragWindowModifier: ViewModifier {
  public func body(content: Content) -> some View {
    content
      .overlay(DragWindowViewNSRep())
  }
}
extension View {
  public func dragWindow() -> some View {
    self.modifier(DragWindowModifier())
  }
}

/// A light-weight wrapper around an `NSView`, to enable use of
/// `NSWindow`'s method `performDrag(with:)` in SwiftUI.
private struct DragWindowViewNSRep: NSViewRepresentable {
  func makeNSView(context: Context) -> NSView {
    DragWindowViewNSView()
  }
  func updateNSView(_ nsView: NSView, context: Context) {}
}

private class DragWindowViewNSView: NSView {
  override public func mouseDown(with event: NSEvent) {
    window?.performDrag(with: event)
  }
}

#endif
