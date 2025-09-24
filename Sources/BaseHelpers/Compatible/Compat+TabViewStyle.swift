//
//  Compat+TabViewStyle.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 24/9/2025.
//

import SwiftUI

public struct SidebarTabViewStyleModifier: ViewModifier {
  
  public func body(content: Content) -> some View {
    if #available(macOS 15, iOS 18, *) {
      content
        .tabViewStyle(.sidebarAdaptable)
    } else {
      content
        .tabViewStyle(.automatic)
    }
  }
}
extension View {
  public func sidebarTabViewStyle() -> some View {
    self.modifier(SidebarTabViewStyleModifier())
  }
}
