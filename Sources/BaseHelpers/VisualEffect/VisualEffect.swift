//
//  VisualEffect.swift
//  Collection
//
//  Created by Dave Coleman on 2/11/2024.
//

import SwiftUI

// MARK: - Visual effect
#if os(macOS)

private struct VisualEffectView: NSViewRepresentable {
  func makeNSView(context: Context) -> NSView {
    let view = NSVisualEffectView()
    view.blendingMode = .behindWindow
    view.material = .popover
    return view
  }
  func updateNSView(_ view: NSView, context: Context) {}
}

public struct VisualEffectModifier: ViewModifier {

  public func body(content: Content) -> some View {
    content
      .background {
        VisualEffectView()
      }
    /// Note: best to use `ignoresSafeArea` in app, as
    /// appearance in Previews can be troublesome
    // .ignoresSafeArea()
  }
}
extension View {
  public func visualEffectBackground() -> some View {
    self.modifier(VisualEffectModifier())
  }
}

#endif
