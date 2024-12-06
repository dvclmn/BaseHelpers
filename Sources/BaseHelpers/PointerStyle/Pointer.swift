//
//  Pointer.swift
//  Collection
//
//  Created by Dave Coleman on 19/9/2024.
//


#if canImport(AppKit)

public protocol CompatiblePointerStyle {
  associatedtype Value
  
  @available(macOS 15, iOS 18, *)
  var containerKeyPath: WritableKeyPath<ContainerValues, Value> { get }
}

public enum CustomPointer {
  case `default`
  
}

import SwiftUI

//@available(macOS 15, iOS 18, *)
public struct CustomPointerModifier: ViewModifier {
  var style: PointerStyle
  
  public func body(content: Content) -> some View {
    
    if #available(macOS 15, *) {
      content
        .pointerStyle(style)
    } else {
      content
    }
  }
}

public extension View {
  @ViewBuilder
  func customPointer(_ pointerStyle: CompatiblePointerStyle) -> some View {
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
