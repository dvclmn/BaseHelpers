//
//  MidpointModifier.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 7/5/2025.
//

import SwiftUI

public struct MidpointModifier: ViewModifier {

  @State private var viewSize: CGSize = .zero

  let colour: Color

  public func body(content: Content) -> some View {
    content
      .viewSize(mode: .debounce()) { viewSize = $0 }
      .overlay {
        Circle()
          .fill(colour.opacity(0.4))
          .frame(width: 10, height: 10)
          .position(viewSize.midpoint)
      }
  }
}
extension View {
  public func midpointIndicator(
    colour: Color = .cyan
  ) -> some View {
    self.modifier(MidpointModifier(colour: colour))
  }
}
