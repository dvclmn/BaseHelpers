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
  
  public init(
    mode: MaskMode = .mask,
    edge: Edge = .top
  ) {
    self.mode = mode
    self.edge = edge
  }
}

public struct ScrollOffsetModifier: ViewModifier {
  
  let mask: MaskConfig
  
  let showsIndicators: Bool
  let safeAreaPadding: (edge: Edge.Set, padding: CGFloat?)
  let output: (_ offset: CGPoint) -> Void
  
  @State private var scrollOffset: CGFloat = .zero
  
  public func body(content: Content) -> some View {
    
    ScrollViewWithOffsetTracking(showsIndicators: showsIndicators) { offset in
      if mask.mode != .off {
        scrollOffset = offset.y * -1
      }
      output(offset)
    } content: {
      content
        .safeAreaPadding(safeAreaPadding.edge, safeAreaPadding.padding)
    }
    .contentMargins(safeAreaPadding.edge, safeAreaPadding.padding, for: .scrollIndicators)
    //              .frame(maxWidth: .infinity, maxHeight: .infinity)
    //    .scrollClipDisabled(isClipDisabled)
    .scrollMask(scrollOffset: scrollOffset, maskMode: mask.mode)
  }
}

public extension View {
  
  func scrollWithOffset(
    mask: MaskConfig = MaskConfig(),
    showsIndicators: Bool = true,
    safeAreaPadding: (Edge.Set, CGFloat?) = (.all, .zero),
    _ output: @escaping (_ offset: CGPoint) -> Void = { _ in }
  ) -> some View {
    self.modifier(ScrollOffsetModifier(
      mask: mask,
      showsIndicators: showsIndicators,
      safeAreaPadding: safeAreaPadding,
      output: output
    ))
  }
  
}



//public extension View {
//    func readSize(
//        onChange: @escaping (CGSize) -> Void
//    ) -> some View {
//
//        background(
//            GeometryReader { geometryProxy in
//                Color.clear
//                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
//            }
//        )
//        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
//    }
//}
//
//private struct SizePreferenceKey: PreferenceKey {
//    static var defaultValue: CGSize = .zero
//    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
//}
//


//public struct ScrollOffset: Sendable {
//    public var offset: CGPoint
//
//    public init(offset: CGPoint) {
//        self.offset = offset
//    }
//}
//
//public struct ScrollOffsetKey: EnvironmentKey {
//    public static let defaultValue = ScrollOffset(offset: .zero)
//}
//
//public extension EnvironmentValues {
//    var scrollOffset: ScrollOffset {
//        get { self[ScrollOffsetKey.self] }
//        set { self[ScrollOffsetKey.self] = newValue }
//    }
//}
