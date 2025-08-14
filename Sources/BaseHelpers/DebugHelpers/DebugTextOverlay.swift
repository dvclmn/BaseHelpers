//
//  DebugTextOverlay.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 11/8/2025.
//

import SwiftUI

public struct DebugTextOverlayModifier: ViewModifier {

  let value: String
  let alignment: Alignment
  public func body(content: Content) -> some View {
    content
      .overlay(alignment: alignment) {
        Text(value)
          .modifier(DebugTextStyleModifier())
          .allowsHitTesting(false)
      }
  }
}
import SwiftUI

public struct DebugTextStyleModifier: ViewModifier {
  
  public func body(content: Content) -> some View {
    content
      .font(.callout)
      .foregroundStyle(.primary.opacity(0.8))
      .monospacedDigit()
      .padding(.horizontal, 6)
      .padding(.vertical, 4)
      .background(.regularMaterial)
      .background(.black.lowOpacity)
      .clipShape(.rect(cornerRadius: 3))
      .padding()
  }
}

extension View {
  public func debugTextOverlay(
    _ value: String,
    alignment: Alignment = .topLeading
  ) -> some View {
    self.modifier(
      DebugTextOverlayModifier(
        value: value,
        alignment: alignment
      )
    )
  }
}
