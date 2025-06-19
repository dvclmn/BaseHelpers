//
//  PointerStyleModifier.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/6/2025.
//

#if canImport(AppKit)
import SwiftUI

// MARK: - ViewModifier
private struct CustomPointerModifier: ViewModifier {
  let style: CompatiblePointerStyle?
  
  func body(content: Content) -> some View {
    if #available(macOS 15, *) {
      content.pointerStyle(style?.toPointerStyle)
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
  public func setPointerStyle(_ style: CompatiblePointerStyle?) -> some View {
    modifier(CustomPointerModifier(style: style))
  }
}
#endif
