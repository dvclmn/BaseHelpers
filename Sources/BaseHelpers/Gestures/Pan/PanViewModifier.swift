//
//  TestPanGestureModifier.swift
//  Paperbark
//
//  Created by Dave Coleman on 24/6/2025.
//

import SwiftUI

#if canImport(AppKit)
public struct PanGestureModifier: ViewModifier {

  let isEnabled: Bool
  let action: (PanPhase) -> Void

  public func body(content: Content) -> some View {
    /// Keeping this as a GeometryReader as layout
    /// gets messed up without it
    ZStack {
      //    GeometryReader { _ in
      content
      if isEnabled {
        PanGestureView { phase in
          action(phase)
        }
      }
    }
  }
}
extension View {
  public func onPanGesture(
    isEnabled: Bool = true,
    _ action: @escaping (PanPhase) -> Void
  ) -> some View {
    self.modifier(
      PanGestureModifier(
        isEnabled: isEnabled,
        action: action
      )
    )
  }
}
#endif
