//
//  DebugFrameModifier.swift
//  BaseComponents
//
//  Created by Dave Coleman on 25/6/2025.
//

import SwiftUI

public struct DebugFrameModifier: ViewModifier {
  
  let label: String
  let colour: Color
  
  public func body(content: Content) -> some View {
    content
      .overlay {
        Rectangle()
          .fill(.clear)
          .stroke(colour, lineWidth: 1)
      }
      .overlay(alignment: .topLeading) {
        Text(label)
          .font(.callout)
          .foregroundStyle(colour)
          .padding()
      }
  }
}
extension View {
  public func debugFrame(_ text: String, _ colour: Color) -> some View {
    self.modifier(DebugFrameModifier(label: text, colour: colour))
  }
}
