//
//  Pointer.swift
//  Collection
//
//  Created by Dave Coleman on 19/9/2024.
//


#if canImport(AppKit)

import SwiftUI

// MARK: - ViewModifier
@available(macOS 15, *)
public struct CustomPointerModifier: ViewModifier {
  let style: PointerStyle
  
  public func body(content: Content) -> some View {
    content.pointerStyle(style)
  }
}

// MARK: - View Extension
public extension View {
  @ViewBuilder
  func customPointer(_ style: @autoclosure () -> PointerStyle) -> some View {
    if #available(macOS 15, *) {
      modifier(CustomPointerModifier(style: style()))
    } else {
      self
    }
  }
}

#endif


struct BoxPrintView: View {
  
  var body: some View {
    
    Text("Hello")
      .customPointer(.grabActive)
      .padding(40)
      .frame(width: 600, height: 700)
      .background(.black.opacity(0.6))
    
  }
}
