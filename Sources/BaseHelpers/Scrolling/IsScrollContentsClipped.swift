//
//  IsScrollContentsClipped.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/5/2025.
//

import SwiftUI

struct HorizontalScrollState: Equatable {
  var isClipped: Bool = false
  var isAtStart: Bool = false
  var isAtEnd: Bool = false
}


public struct IsScrollContentClippedModifier: ViewModifier {
  
//  @State private var scrollState
  
  let scrollState: (HorizontalScrollState) -> Void
//  let isClipped: (Bool) -> Void
  public func body(content: Content) -> some View {
    if #available(macOS 15.0, *) {
      content
        .onScrollGeometryChange(for: HorizontalScrollState.self) { geometry in
            
            /// Is Clipped
            let containerWidth = geometry.containerSize.width
            let contentsWidth = geometry.contentSize.width
            let isClipped = containerWidth < contentsWidth
            
            /// Is at start/end
            let visibleMinX = geometry.visibleRect.minX
            let visibleMaxX = geometry.visibleRect.maxX
            let contentMaxX = geometry.contentSize.width
            let tolerance: CGFloat = 1.0
            
            let isAtStart = visibleMinX <= tolerance
            let isAtEnd = visibleMaxX >= (contentMaxX - tolerance)

            let state = HorizontalScrollState(
              isClipped: isClipped,
              isAtStart: isAtStart,
              isAtEnd: isAtEnd
            )
            
            return state
            
          } action: { _, newValue in
            scrollState(newValue)
        }
      
    } else {
      
      content
    }
  }
}


public struct IsScrolledToEnd: ViewModifier {
  
  let isScrolledToEnd: (Bool) -> Void
  public func body(content: Content) -> some View {
    if #available(macOS 15.0, *) {
      content
        .onScrollGeometryChange(
          for: Bool.self,
          of: { geometry in
            
           
            
            //            print(
            //              """
            //              Vis rect: \(geometry.visibleRect)
            //              Content offset: \(geometry.contentOffset)
            //              Container size: \(geometry.containerSize)
            //              Content size: \(geometry.contentSize)
            //              At end? \(isAtEnd)
            //              """)
            
            return isAtEnd
            
          },
          action: { _, newValue in
            isScrolledToEnd(newValue)
          })
      
    } else {
      
      content
    }
  }
}

public extension View {
  func isScrollContentClipped(
    isClipped: @escaping (Bool) -> Void
  ) -> some View {
    self.modifier(IsScrollContentClippedModifier(isClipped: isClipped))
  }
}

//
//extension View {
//  public func isScrolledToEnd(
//    isScrolledToEnd: @escaping (Bool) -> Void
//  ) -> some View {
//    self.modifier(IsScrolledToEnd(isScrolledToEnd: isScrolledToEnd))
//  }
//}
