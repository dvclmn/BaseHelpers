//
//  File.swift
//
//
//  Created by Dave Coleman on 14/7/2024.
//

import Foundation
import SwiftUI
//import ScrollKit

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

public struct SafePadding {
  let edges: Edge.Set
  let padding: CGFloat
  
  public init(_ edges: Edge.Set, _ padding: CGFloat) {
    self.edges = edges
    self.padding = padding
  }
}

//public typealias SafePadding = (edges: Edge.Set, padding: CGFloat?)

public struct ScrollOffsetModifier: ViewModifier {
  
  let maskConfig: MaskConfig
  let showsIndicators: Bool
  let safePadding: SafePadding
  let output: (_ offset: CGPoint) -> Void
  
  @State private var scrollOffset: CGFloat = .zero
  
  public func body(content: Content) -> some View {
    
    content
      .overlay {
        Text("Need to implement")
      }
    
//    ScrollViewWithOffsetTracking(showsIndicators: showsIndicators) { offset in
//      if maskConfig.mode != .off {
//        scrollOffset = offset.y * -1
//      }
//      output(offset)
//    } content: {
//      content
//        .safeAreaPadding(safePadding.edges, safePadding.padding)
//    }
//    .contentMargins(safePadding.edges, safePadding.padding, for: .scrollIndicators)
//    .scrollMask(
//      scrollOffset: scrollOffset,
//      config: maskConfig
//    )
  }
}

public extension View {
  
  func scrollWithOffset(
    maskMode: MaskMode = .mask,
    edge: Edge = .top,
    edgePadding: CGFloat = 30,
    maskLength: CGFloat = 130,
    showsIndicators: Bool = true,
    safePadding: SafePadding = .init(.all, .zero),
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
        safePadding: safePadding,
        output: output
      )
    )
  }
  
}

