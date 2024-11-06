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
    
    if #available(macOS 15.0, *) {
      content
        .textRenderer(renderer)
    } else {
      content
    }
  }
}
public extension View where Self == Text {
  func renderText<T: TextRenderer>(_ renderer: T) -> some View {
    self.modifier(
      TextRender(renderer)
    )
  }
}
