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
        .onScrollGeometryChange(
          for: Bool.self,
          of: { geometry in

            let visibleMaxX = geometry.visibleRect.maxX
            let contentMaxX = geometry.contentSize.width
            let tolerance: CGFloat = 1.0

            let isAtEnd = visibleMaxX >= (contentMaxX - tolerance)

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
extension View {
  public func isScrolledToEnd(
    isScrolledToEnd: @escaping (Bool) -> Void
  ) -> some View {
    self.modifier(IsScrolledToEnd(isScrolledToEnd: isScrolledToEnd))
  }
}
