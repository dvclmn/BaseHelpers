//
//  MidpointModifier.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 7/5/2025.
//

import SwiftUI

public struct MidpointModifier: ViewModifier {
  
  @State private var viewSize: CGSize = .zero
  
  let rect: CGRect?
  let colour: Color
  
  public func body(content: Content) -> some View {
    content
      .onGeometryChange(for: CGSize.self) { proxy in
        return proxy.size
      } action: { newValue in
        viewSize = newValue
      }
      .overlay {
        Circle()
          .fill(colour.opacity(0.4))
          .frame(width: 10, height: 10)
          .position(viewSize.centrePoint)
      }
  }
}
extension MidpointModifier {
//  var position: CGPoint {
//    if let rect {
//      return rect.
//    }
//  }
}

public extension View {
  func midpointIndicator(
    rect: CGRect? = nil,
    colour: Color = .cyan
  ) -> some View {
    self.modifier(MidpointModifier(rect: rect, colour: colour))
  }
}
