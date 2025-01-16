//
//  Toolbar.swift
//  Collection
//
//  Created by Dave Coleman on 15/1/2025.
//


//#if canImport(AppKit)
//import SwiftUI

//enum CustomToolbarRemoval

//
//// MARK: - ViewModifier
//private struct ToolbarItemRemovalModifier: ViewModifier {
////  let type: CustomPointerType
//  
//  func body(content: Content) -> some View {
//    if #available(macOS 15, *) {
//      content.toolbar(removing: .title)
//    } else {
//      content
//    }
//  }
//}

//// MARK: - View Extension
//public extension View {
//  /// Applies a custom pointer style to a view that gracefully degrades on older macOS versions.
//  /// - Parameter type: The desired pointer style type.
//  /// - Returns: A view with the specified pointer style applied (macOS 15+) or unchanged (earlier versions).
//  func toolbarItemRemoval(_ type: CustomPointerType) -> some View {
//    modifier(CustomPointerModifier(type: type))
//  }
//}
//#endif
