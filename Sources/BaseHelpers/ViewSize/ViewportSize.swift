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
  let didUpdateSize: ViewSizeOutput?
  public init(
    didUpdateSize: ViewSizeOutput?
  ) {
    self.didUpdateSize = didUpdateSize
  }
  public func body(content: Content) -> some View {
    content
      .viewSize { size in
        self.viewportSize = size
        didUpdateSize?(size)
      }
      .environment(\.viewportSize, viewportSize)
  }
}
extension View {
  public func readViewportSize(
    didUpdateSize: ViewSizeOutput? = nil
  ) -> some View {
    self.modifier(
      ViewportSizeModifier(
        didUpdateSize: didUpdateSize
      )
    )
  }
}
