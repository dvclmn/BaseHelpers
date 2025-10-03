//
//  Compat+SplitViews.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 22/9/2025.
//


import SwiftUI

/// Just calling this stack so as not to clash with native `VSplitView`
public struct VSplitStack<Content: View>: View {
  
  let content: Content
  
  public init(
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.content = content()
  }
  
  public var body: some View {
    
#if canImport(AppKit)
    VSplitView {
      content
    }
#else
    VStack {
      content
    }
#endif
  }
}
