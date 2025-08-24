//
//  IsViewCompactModifier.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/5/2025.
//

import SwiftUI

public typealias IsViewCompactHandler = (Bool) -> Void

public struct IsViewCompactModifier: ViewModifier {
  @State private var isCompact: Bool = false
  let widthThreshold: CGFloat
  //  let allowEnvironmentUpdate: Bool
  let didUpdateCompactStatus: IsViewCompactHandler

  public func body(content: Content) -> some View {
    content
      .onGeometryChange(for: Bool.self) { proxy in
        return proxy.size.width < widthThreshold

      } action: { newValue in
        print("Is View compact?: \(newValue)")
        self.isCompact = newValue
        didUpdateCompactStatus(newValue)
      }
      .environment(\.isCompactMode, isCompact)
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
    //    allowEnvironmentUpdate: Bool = true
  ) -> some View {
    self.modifier(
      IsViewCompactModifier(
        widthThreshold: widthThreshold,
        //        allowEnvironmentUpdate: allowEnvironmentUpdate,
        didUpdateCompactStatus: didUpdateCompactStatus
      )
    )
  }
}
