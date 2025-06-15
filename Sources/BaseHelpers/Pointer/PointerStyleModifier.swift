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
  let type: CompatiblePointerStyle
  
  func body(content: Content) -> some View {
    if #available(macOS 15, *) {
      content.pointerStyle(type.toPointerStyle)
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
  public func customPointer(_ type: CompatiblePointerStyle) -> some View {
    modifier(CustomPointerModifier(type: type))
  }
}
#endif
