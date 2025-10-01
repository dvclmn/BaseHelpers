//
//  Compat+ScrollPosition.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/10/2025.
//

import SwiftUI

///// A compatibility wrapper for the new scrollPosition modifier (macOS 15+, iOS 18+)
//public struct ScrollPositionCompatibleModifier<Item: Hashable & Sendable>: ViewModifier {
//
//  @Binding var position: ScrollPositionCompatible<Item>
//  let anchor: UnitPoint?
//
//  public func body(content: Content) -> some View {
//    if #available(macOS 15.0, iOS 18.0, *) {
//      content.scrollPosition(positionBinding(), anchor: anchor)
//
//    } else {
//      content
//    }
//  }
//}
//
//@available(macOS 15.0, iOS 18.0, *)
//extension ScrollPositionCompatibleModifier {
//  private func positionBinding() -> Binding<ScrollPosition> {
//    return Binding {
//      return position.toScrollPosition()
//    } set: { newValue in
//      //      let new = ScrollPosition(idType: newValue.viewID)
//    }
//
//  }
//}
//
//extension View {
//  public func compatScrollPosition<Item: Hashable & Sendable>(
//    _ position: Binding<ScrollPositionCompatible<Item>>,
//    anchor: UnitPoint? = nil
//  ) -> some View {
//    self.modifier(
//      ScrollPositionCompatibleModifier(
//        position: position,
//        anchor: anchor
//      )
//    )
//  }
//}
//
//public struct ScrollPositionCompatible<Item: Hashable & Sendable>: Sendable {
//  let idType: Item.Type
//  let edge: Edge
//  public init(idType: Item.Type, edge: Edge = .top) {
//    self.idType = idType
//    self.edge = edge
//  }
//}
//
//@available(macOS 15.0, iOS 18.0, *)
//extension ScrollPositionCompatible {
//  public func toScrollPosition() -> ScrollPosition {
//    ScrollPosition(idType: idType, edge: edge)
//  }
//}
