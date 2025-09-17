//
//  Compat+BGExtension.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//

import SwiftUI

public struct CompatibleBGExtensionEffectModifier: ViewModifier {
  
  public func body(content: Content) -> some View {
    if #available(macOS 26, iOS 26, *) {
      content
        .backgroundExtensionEffect()
    } else {
      content
    }
  }
}
extension View {
  public func backgroundExtensionCompatible() -> some View {
    self.modifier(CompatibleBGExtensionEffectModifier())
  }
}
