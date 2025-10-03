//
//  ItemFrames.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/10/2025.
//

import SwiftUI

//@Observable
//final class CanvasHandler<Item: Identifiable> {
//public struct FrameHandler<Item: Identifiable> {
//  var frames: [Item.ID: CGRect] = [:]
//  var viewSize: CGSize?
//  
//}

/// To be applied to a *single* item, like per-item
//public struct ItemFramesModifier<Item: Identifiable>: ViewModifier {
//  
//  @State private var frames: [Item.ID: CGRect] = [:]
//  
////  let items: [Item]
//  let item: Item
//  let containerSize: CGSize
//  
//  public func body(content: Content) -> some View {
//    content
//      .viewSize(capture: .frameInScrollView, mode: .debounce()) { frame in
//        updateIfChanged(&frames[item.id], to: frame)
////        handler.updateItemFrame(id: item.id, frame: frame)
//      }
//  }
//}
//extension ItemFramesModifier {
//  private func updateFrame(id: Item.ID, frame: CGRect) {
//    updateIfChanged(&frames[id], to: frame)
//  }
//}

//extension View {
//  public func example() -> some View {
//    self.modifier(ItemFramesModifier())
//  }
//}
