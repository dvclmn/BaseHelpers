//
//  IsScrolledToEnd.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/5/2025.
//

import SwiftUI

public struct IsScrolledToEnd: ViewModifier {
  
  let isScrolledToEnd: (Bool) -> Void
  public func body(content: Content) -> some View {
    if #available(macOS 15.0, *) {
      content
        .onScrollGeometryChange(for: Bool.self, of: { geometry in
          
          /// How do we figure out if the content is resting at the end?
          ///
          /// - We need the full content
          ///
          /// Note: 
          
          print("""
            
            
            Vis rect: \(geometry.visibleRect)
            Content offset: \(geometry.contentOffset)
            Container size: \(geometry.containerSize)
            Content size: \(geometry.contentSize)
            
            Attempted logic: 
            
            """)
          
          return false
          
//          let containerWidth = geometry.containerSize.width
//          let contentsWidth = geometry.contentSize.width
//          return containerWidth < contentsWidth
        }, action: { _, newValue in
          isScrolledToEnd(newValue)
        })
      
    } else {
      
      content
    }
  }
}
public extension View {
  func isScrolledToEnd(
    isScrolledToEnd: @escaping (Bool) -> Void
  ) -> some View {
    self.modifier(IsScrolledToEnd(isScrolledToEnd: isScrolledToEnd))
  }
}
