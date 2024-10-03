//
//  File.swift
//
//
//  Created by Dave Coleman on 14/7/2024.
//

import Foundation
import SwiftUI
import ScrollKit

/// Will make this optional, and do away with the `maskEnabled`
/// property, as a nil value for a mask config will serve the same purpose.
public struct MaskConfig {
  var mode: MaskMode
  var edge: Edge
  var edgePadding: CGFloat
  var length: CGFloat
  
  public init(
    mode: MaskMode = .mask,
    edge: Edge = .top,
    edgePadding: CGFloat,
    length: CGFloat = 130
  ) {
    self.mode = mode
    self.edge = edge
    self.edgePadding = edgePadding
    self.length = length
  }
}

public struct ScrollOffsetModifier: ViewModifier {
  
  let maskConfig: MaskConfig
  let showsIndicators: Bool
  let safeAreaPadding: (edge: Edge.Set, padding: CGFloat?)
  let output: (_ offset: CGPoint) -> Void
  
  @State private var scrollOffset: CGFloat = .zero
  
  public func body(content: Content) -> some View {
    
    ScrollViewWithOffsetTracking(showsIndicators: showsIndicators) { offset in
      if maskConfig.mode != .off {
        scrollOffset = offset.y * -1
      }
      output(offset)
    } content: {
      content
        .safeAreaPadding(safeAreaPadding.edge, safeAreaPadding.padding)
    }
    .contentMargins(safeAreaPadding.edge, safeAreaPadding.padding, for: .scrollIndicators)
    .scrollMask(
      scrollOffset: scrollOffset,
      config: maskConfig
    )
  }
}

public extension View {
  
  func scrollWithOffset(
    maskMode: MaskMode = .mask,
    edge: Edge = .top,
    edgePadding: CGFloat = 30,
    maskLength: CGFloat = 130,
    showsIndicators: Bool = true,
    safeAreaPadding: (Edge.Set, CGFloat?) = (.all, .zero),
    _ output: @escaping (_ offset: CGPoint) -> Void = { _ in }
  ) -> some View {
    self.modifier(
      ScrollOffsetModifier(
        maskConfig: MaskConfig(
          mode: maskMode,
          edge: edge,
          edgePadding: edgePadding,
          length: maskLength
        ),
        showsIndicators: showsIndicators,
        safeAreaPadding: safeAreaPadding,
        output: output
      )
    )
  }
  
}

