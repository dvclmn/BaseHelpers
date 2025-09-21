//
//  Compat+GlassEffect.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 20/9/2025.
//

import SwiftUI

public struct CompatibleGlassModifier<S: Shape>: ViewModifier {
  
  let shape: S
  public func body(content: Content) -> some View {
    if #available(macOS 26, iOS 26, *) {
      content
        .glassEffect(.regular, in: shape)
    } else {
      content
    }
  }
}
extension View {
  public func compatibleGlass<S: Shape>(_ shape: S) -> some View {
    self.modifier(CompatibleGlassModifier(shape: shape))
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
