//
//  TextRenderer.swift
//  Collection
//
//  Created by Dave Coleman on 6/11/2024.
//

import SwiftUI

public struct TextRender<T: TextRenderer>: ViewModifier {

  let renderer: T

  public init(
    _ renderer: T
  ) {
    self.renderer = renderer
  }

  public func body(content: Content) -> some View {

    if #available(macOS 15, iOS 18, *) {
      content
        .textRenderer(renderer)
    } else {
      content
    }
  }
}
extension View where Self == Text {
  public func renderText<T: TextRenderer>(_ renderer: T) -> some View {
    self.modifier(
      TextRender(renderer)
    )
  }
}


extension Text.Layout {
  public var flattenedRunSlices: some RandomAccessCollection<Text.Layout.RunSlice> {
    flattenedRuns.flatMap(\.self)
  }

  public var flattenedRuns: some RandomAccessCollection<Text.Layout.Run> {
    flatMap { line in
      line
    }
  }
}
