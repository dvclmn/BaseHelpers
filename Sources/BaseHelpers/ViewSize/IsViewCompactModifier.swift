//
//  IsViewCompactModifier.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/5/2025.
//

import SwiftUI

public typealias IsViewCompactHandler = (Bool) -> Void

public struct IsViewCompactModifier: ViewModifier {
  @Environment(\.isPreviewOnlyDebugMode) private var isPreviewOnlyDebugMode

  @State private var isCompact: Bool = false
  let widthThreshold: CGFloat
  let didUpdateCompactStatus: IsViewCompactHandler

  public func body(content: Content) -> some View {
    content
      .onGeometryChange(for: Bool.self) { proxy in
        let isCompact = proxy.size.width < widthThreshold
        return isCompact

      } action: { newValue in
        print("Is View compact?: \(newValue)")
        self.isCompact = newValue
        didUpdateCompactStatus(newValue)
      }
      .environment(\.isCompactMode, isCompact)
      .overlay(alignment: .bottomLeading) {
        DebugView()
      }
  }
}
extension IsViewCompactModifier {
  @ViewBuilder
  private func DebugView() -> some View {
    if isPreviewOnlyDebugMode {
      Text("Size: " + "\(isCompact ? "Compact" : "Normal")")
        .font(.caption)
        .foregroundStyle(.quaternary)
        .weightedPadding(Styles.sizeNano, horizontalBias: 2.4)
        .padding(Styles.sizeTiny)
        .allowsHitTesting(false)
    }
  }
}
extension View {
  /// This modifier will also update the `isCompactMode`
  /// Environment Value
  public func isViewCompact(
    widthThreshold: CGFloat,
    //    didUpdateCompactStatus: @escaping IsViewCompactHandler,
    //    allowEnvironmentUpdate: Bool = true
  ) -> some View {
    self.modifier(
      IsViewCompactModifier(
        widthThreshold: widthThreshold,
        //        allowEnvironmentUpdate: allowEnvironmentUpdate,
        didUpdateCompactStatus: { _ in }
      )
    )
  }

  public func isViewCompact(
    widthThreshold: CGFloat,
    didUpdateCompactStatus: @escaping IsViewCompactHandler,
  ) -> some View {
    self.modifier(
      IsViewCompactModifier(
        widthThreshold: widthThreshold,
        didUpdateCompactStatus: didUpdateCompactStatus
      )
    )
  }
}
