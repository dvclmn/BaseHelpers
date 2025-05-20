//
//  IsScrollContentsClipped.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/5/2025.
//

import SwiftUI

public enum HorizontalMask {
  case startOnly
  case startAndEnd
  case endOnly
  case none

  public init(scrollState: HorizontalScrollState) {

    /// If nothing is clipped, then we don't need to mask anything
    guard scrollState.isClipped else {
      self = .none
      return
    }
    if scrollState.isAtStart {
      self = .endOnly
      
    } else if scrollState.isAtEnd {
      self = .startOnly
      
    } else {
      self = .startAndEnd
    }
  }
}

public struct HorizontalScrollState: Equatable {
  public var isClipped: Bool
  public var isAtStart: Bool
  public var isAtEnd: Bool

  public init(
    isClipped: Bool = false,
    isAtStart: Bool = false,
    isAtEnd: Bool = false
  ) {
    self.isClipped = isClipped
    self.isAtStart = isAtStart
    self.isAtEnd = isAtEnd
  }

  public var masking: HorizontalMask {
    .init(scrollState: self)
  }
}


public struct ScrollStateModifier: ViewModifier {

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


//public struct IsScrolledToEnd: ViewModifier {
//
//  let isScrolledToEnd: (Bool) -> Void
//  public func body(content: Content) -> some View {
//    if #available(macOS 15.0, *) {
//      content
//        .onScrollGeometryChange(
//          for: Bool.self,
//          of: { geometry in
//
//
//
//            //            print(
//            //              """
//            //              Vis rect: \(geometry.visibleRect)
//            //              Content offset: \(geometry.contentOffset)
//            //              Container size: \(geometry.containerSize)
//            //              Content size: \(geometry.contentSize)
//            //              At end? \(isAtEnd)
//            //              """)
//
//            return isAtEnd
//
//          },
//          action: { _, newValue in
//            isScrolledToEnd(newValue)
//          })
//
//    } else {
//
//      content
//    }
//  }
//}

extension View {
  public func scrollState(
    state: @escaping (HorizontalScrollState) -> Void
  ) -> some View {
    self.modifier(ScrollStateModifier(scrollState: state))
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
