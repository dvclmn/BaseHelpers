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
    view.state = .active
    view.material = .underWindowBackground
    return view
  }
  public func updateNSView(_ view: NSView, context: Context) { }
}
#endif

