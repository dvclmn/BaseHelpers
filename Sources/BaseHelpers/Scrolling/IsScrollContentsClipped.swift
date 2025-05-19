//
//  IsScrollContentsClipped.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/5/2025.
//

import SwiftUI

public struct IsScrollContentClippedModifier: ViewModifier {
  
  let isClipped: (Bool) -> Void
  public func body(content: Content) -> some View {
    if #available(macOS 15.0, *) {
      content
        .onScrollGeometryChange(for: Bool.self, of: { geometry in
          let containerWidth = geometry.containerSize.width
          let contentsWidth = geometry.contentSize.width
          return containerWidth < contentsWidth
        }, action: { _, newValue in
          isClipped(newValue)
        })
      
    } else {
      
      content
    }
  }
}
public extension View {
  func isScrollContentClipped(
    isClipped: @escaping (Bool) -> Void
  ) -> some View {
    self.modifier(IsScrollContentClippedModifier(isClipped: isClipped))
  }
}


