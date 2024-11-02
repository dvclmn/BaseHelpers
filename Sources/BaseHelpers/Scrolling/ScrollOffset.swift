//
//  File.swift
//
//
//  Created by Dave Coleman on 14/7/2024.
//

import Foundation
import SwiftUI

public typealias OffsetOutput = (_ offset: CGPoint) -> Void

public struct OffsetScroll<Content: View>: View {
  
  @State private var offset: CGFloat = .zero
  
  let maskConfig: MaskConfig
  let showsIndicators: Bool
  let safePadding: SafePadding
  let output: OffsetOutput
  
  let content: Content
  
  public init(
    config: MaskConfig = .init(),
    
    showsIndicators: Bool = true,
    safePadding: SafePadding = .init(.all, .zero),
    output: @escaping OffsetOutput,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.maskConfig = config
    self.showsIndicators = showsIndicators
    self.safePadding = safePadding
    self.output = output
    self.content = content()
  }
  
  public var body: some View {
    
    ScrollView {
      VStack {
        content
      }
      //      .trackScrollOffset { point in
      ////        print("Debounced scroll offset: \(point)")
      //        self.offset = point.y
      //      }
      .readFrame { point in
        self.offset = point.y
        self.output(point)
      }
    }
    .scrollMask(
      scrollOffset: self.offset,
      config: maskConfig
    )
    .coordinateSpace(name: "scroll")
    //    .overlay(alignment: .topLeading) {
    //      Text("Scroll offset: \(self.offset)")
    //    }
    
  }
}



//public extension View {
//
//  func scrollWithOffset(
//    maskMode: MaskMode = .mask,
//    edge: Edge = .top,
//    edgePadding: CGFloat = 30,
//    maskLength: CGFloat = 130,
//    showsIndicators: Bool = true,
//    safePadding: SafePadding = .init(.all, .zero),
//    _ output: @escaping (_ offset: CGPoint) -> Void = { _ in }
//  ) -> some View {
//    self.modifier(
//      ScrollOffsetModifier(
//        maskConfig: MaskConfig(
//          mode: maskMode,
//          edge: edge,
//          edgePadding: edgePadding,
//          length: maskLength
//        ),
//        showsIndicators: showsIndicators,
//        safePadding: safePadding,
//        output: output
//      )
//    )
//  }
//
//}

