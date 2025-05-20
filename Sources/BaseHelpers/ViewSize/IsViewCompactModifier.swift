//
//  IsViewCompactModifier.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/5/2025.
//

import SwiftUI

public typealias IsViewCompactHandler = (Bool) -> Void

public struct IsViewCompactModifier: ViewModifier {
  
  let widthThreshold: CGFloat
  let didUpdateCompactStatus: IsViewCompactHandler
  
  public func body(content: Content) -> some View {
    content
      .onGeometryChange(for: Bool.self) { proxy in
        return proxy.size.width < widthThreshold
//        return proxy.size
      } action: { newValue in
        didUpdateCompactStatus(newValue)
      }
  }
}
extension View {
  public func isViewCompact(
    widthThreshold: CGFloat = 380,
    didUpdateCompactStatus: @escaping IsViewCompactHandler
  ) -> some View {
    self.modifier(
      IsViewCompactModifier(
        widthThreshold: widthThreshold,
        didUpdateCompactStatus: didUpdateCompactStatus
      )
    )
  }
}
