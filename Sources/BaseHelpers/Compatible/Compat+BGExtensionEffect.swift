//
//  Compat+BGExtension.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/9/2025.
//

import SwiftUI

public struct BackgroundExtensionEffectCompatibleModifier: ViewModifier {

  let isEnabled: Bool
  public func body(content: Content) -> some View {
    if #available(macOS 26, iOS 26, *) {
      content
        .backgroundExtensionEffect(isEnabled: isEnabled)
    } else {
      content
    }
  }
}
extension View {
  public func backgroundExtensionCompatible(isEnabled: Bool = true) -> some View {
    self.modifier(BackgroundExtensionEffectCompatibleModifier(isEnabled: isEnabled))
  }
}
