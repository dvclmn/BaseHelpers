//
//  Compat+ContainerBG.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 23/9/2025.
//

import SwiftUI

public struct ContainerBackgroundCompatibleModifier: ViewModifier {

  public func body(content: Content) -> some View {

    if #available(macOS 26, iOS 26, *) {
      content
        .containerBackground(for: .window, alignment: .leading) {
          Color.brown
        }
    } else {
      content
    }
  }
}
extension View {
  public func containerBackgroundCompatible() -> some View {
    self.modifier(ContainerBackgroundCompatibleModifier())
  }
}
