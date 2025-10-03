//
//  Compat+GlassEffect.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 20/9/2025.
//

import SwiftUI

extension View {
  @ViewBuilder
  public func glassEffectCompatible<S: Shape>(_ shape: S) -> some View {
    if #available(macOS 26, iOS 26, *) {
      glassEffect(.regular, in: shape)
    } else {
      self
    }
  }
}

//import SwiftUI
//
//public struct GlassContainer<Content: View>: View {
//  
//  let content: Content
//  
//  public init(
//    @ViewBuilder content: @escaping () -> Content
//  ) {
//    self.content = content()
//  }
//  
//  public var body: some View {
//    content
//  }
//}
