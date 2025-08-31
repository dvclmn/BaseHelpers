//
//  DebugTextOverlay.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 11/8/2025.
//

import SwiftUI

public struct DebugTextOverlayModifier: ViewModifier {
//  @Environment(\.safeAreaPadding) private var safeAreaPadding
  let value: String
  let alignment: Alignment
  let padding: (Edge.Set, CGFloat?)
  public func body(content: Content) -> some View {
    content
      .overlay(alignment: alignment) {
        Text(value)
          .modifier(DebugTextStyleModifier())
          .safeAreaPadding(padding.0, padding.1)
          .allowsHitTesting(false)
      }
  }
}

public struct DebugTextStyleModifier: ViewModifier {

  public func body(content: Content) -> some View {
    content
      .font(.callout)
      .foregroundStyle(.primary.opacity(0.8))
      .monospacedDigit()
      .padding(.horizontal, 6)
      .padding(.vertical, 4)
      .background(.regularMaterial)
      .background(.black.opacityLow)
      .clipShape(.rect(cornerRadius: 3))
      .padding()
  }
}

extension View {
  public func debugTextOverlay(
    _ value: String,
    alignment: Alignment = .topLeading,
    padding: (Edge.Set, CGFloat?) = (.all, nil)
  ) -> some View {
    self.modifier(
      DebugTextOverlayModifier(
        value: value,
        alignment: alignment,
        padding: padding
      )
    )
  }

  public func debugTextOverlay(
    _ value: String...,
    alignment: Alignment = .topLeading,
    padding: (Edge.Set, CGFloat?) = (.all, nil)
  ) -> some View {
    self.modifier(
      DebugTextOverlayModifier(
        value: value.joined(separator: "\n"),
        //        value: value.flatMap().joined(separator: "\n"),
        alignment: alignment,
        padding: padding
      )
    )
  }
}
