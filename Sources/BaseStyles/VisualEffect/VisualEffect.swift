//
//  VisualEffect.swift
//  Collection
//
//  Created by Dave Coleman on 2/11/2024.
//


import SwiftUI

// MARK: - Visual effect
#if os(macOS)

public struct VisualEffectView: NSViewRepresentable {
  public func makeNSView(context: Context) -> NSView {
    let view = NSVisualEffectView()
    view.blendingMode = .behindWindow
    view.material = .sidebar
    return view
  }
  public func updateNSView(_ view: NSView, context: Context) { }
}

public struct VisualEffectModifier: ViewModifier {
  
  public func body(content: Content) -> some View {
    content
      .safeAreaPadding(.top, Styles.toolbarHeightPrimary)
      .background(.black.opacity(0.4))
      .background(VisualEffectView())
      .ignoresSafeArea()
  }
}
public extension View {
  func visualEffectBackground() -> some View {
    self.modifier(VisualEffectModifier())
  }
}


#endif

