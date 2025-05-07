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
      .onGeometryChange(for: CGSize.self) { proxy in
        return proxy.size
      } action: { newValue in
        viewSize = newValue
      }
      .overlay(alignment: .topLeading) {
        Circle()
          .fill(colour.opacity(0.4))
          .frame(width: 10, height: 10)
          .position(viewSize.centrePoint)
      }
  }
}
public extension View {
  func midpointIndicator(colour: Color = .cyan) -> some View {
    self.modifier(MidpointModifier(colour: colour))
  }
}
