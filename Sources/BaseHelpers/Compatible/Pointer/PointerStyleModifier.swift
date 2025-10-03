//
//  PointerStyleModifier.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/6/2025.
//

import SwiftUI


// MARK: - ViewModifier
private struct CustomPointerModifier: ViewModifier {
  let style: PointerStyleCompatible?
  
  func body(content: Content) -> some View {
    if #available(macOS 15, *) {
#if canImport(AppKit)
      content.pointerStyle(style?.toPointerStyle)
#else
      content
#endif
    } else {
      content
    }
  }
}



// MARK: - View Extension
extension View {
  /// Applies a custom pointer style to a view that gracefully degrades on older macOS versions.
  /// - Parameter type: The desired pointer style type.
  /// - Returns: A view with the specified pointer style applied (macOS 15+) or unchanged (earlier versions).
  public func setPointerStyle(_ style: PointerStyleCompatible?) -> some View {
    modifier(CustomPointerModifier(style: style))
  }
}
