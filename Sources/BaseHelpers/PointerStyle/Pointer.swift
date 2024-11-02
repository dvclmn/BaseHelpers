//
//  Pointer.swift
//  Collection
//
//  Created by Dave Coleman on 19/9/2024.
//

#if canImport(AppKit)

import SwiftUI

@available(macOS 15, *)
public struct CustomPointerModifier: ViewModifier {
  var style: PointerStyle
  
  public func body(content: Content) -> some View {
    content
      .pointerStyle(style)
  }
}

public extension View {
  @ViewBuilder
  func customPointer(_ pointerStyle: Any) -> some View {
    if #available(macOS 15, *) {
      if let style = pointerStyle as? PointerStyle {
        self.modifier(CustomPointerModifier(style: style))
      } else {
        self
      }
    } else {
      self
    }
  }
}

#endif
