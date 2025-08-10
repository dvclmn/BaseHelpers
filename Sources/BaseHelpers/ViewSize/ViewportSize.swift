//
//  ViewportSize.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/8/2025.
//

import SwiftUI

/// A Viewport is considered to be a single, self-contained View,
/// not including any native components like Toolbar or Inspector.
public struct ViewportSizeModifier: ViewModifier {
  @State private var viewportSize: CGSize?

  public func body(content: Content) -> some View {
    content
      //      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .viewSize { size in
        self.viewportSize = size
      }
      .environment(\.viewportSize, viewportSize)
  }
}
extension View {
  public func readViewportSize() -> some View {
    self.modifier(ViewportSizeModifier())
  }
}
