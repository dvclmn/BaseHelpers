//
//  Compat+GlassContainer.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/10/2025.
//

import SwiftUI

public struct GlassEffectCompatible<Content: View>: View {
  
  let spacing: CGFloat?
  let content: Content
  
  public init(
    spacing: CGFloat? = nil,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.spacing = spacing
    self.content = content()
  }
  
  public var body: some View {
    
    if #available(macOS 26, iOS 26, *) {
      GlassEffectContainer(spacing: spacing) {
        content
      }
    } else {
      content
    }
  }
}
