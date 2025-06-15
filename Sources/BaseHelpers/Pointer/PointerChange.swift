//
//  PointerLock.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/5/2025.
//

#if canImport(AppKit)
import AppKit
import SwiftUI

//public struct PointerHoverChangeModifier: ViewModifier {
//
//  @State private var isHovering: Bool = false
//  let pointerStyle: NSCursor
//
//  public init(
//    pointerStyle: NSCursor
//  ) {
//    self.pointerStyle = pointerStyle
//  }
//
//  public func body(content: Content) -> some View {
//    if #available(macOS 15, iOS 18, *) {
//      content
//        .onHover { hover in
//          isHovering = hover
//          DispatchQueue.main.async {
//            if isHovering {
//              // See https://stackoverflow.com/a/62984079/7964697 for details.
//              NSApp.windows.forEach { $0.disableCursorRects() }
//              pointerStyle.push()
//              
//            } else {
//              NSCursor.pop()
//              NSApp.windows.forEach { $0.enableCursorRects() }
//            }
//          }
//        }
//    } else {
//      content
//      
//    }
//  }
//}
//extension View {
//  public func pointerChangeOnHover(to style: NSCursor) -> some View {
//    self.modifier(
//      PointerHoverChangeModifier(pointerStyle: style)
//    )
//  }
//}

#endif
