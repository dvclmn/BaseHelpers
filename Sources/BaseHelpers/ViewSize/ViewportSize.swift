//
//  ViewportSize.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/8/2025.
//

import SwiftUI

/// A Viewport is considered to be a single, self-contained View,
/// not including any native components like Toolbar or Inspector.
///
/// This mirrors `ViewSizeModifier` *very* closely, such that
/// I'm not sure if it's existence is warranted.
public struct ViewportSizeModifier: ViewModifier {
  @State private var viewportSize: CGSize?
  
  let mode: DebounceMode
  let didUpdateSize: ViewSizeOutput<CGSize>?

  public func body(content: Content) -> some View {
    content
      .viewSize(mode: mode) { size in
        self.viewportSize = size
        didUpdateSize?(size)
      }
      .environment(\.viewportSize, viewportSize)
  }
}
extension View {
  public func readViewportSize(
    mode debounceMode: DebounceMode,
    didUpdateSize: ViewSizeOutput<CGSize>? = nil
  ) -> some View {
    self.modifier(
      ViewportSizeModifier(
        mode: debounceMode,
        didUpdateSize: didUpdateSize
      )
    )
  }
}
