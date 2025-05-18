//
//  ViewSizeModifier.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 8/5/2025.
//

import SwiftUI

public typealias ViewSizeOutput = (CGSize) -> Void
public typealias ViewLengthOutput = (CGFloat) -> Void

/// `CGSize`, for width and height of view
public struct ViewSizeModifier: ViewModifier {
  let sizeOutput: ViewSizeOutput
  public func body(content: Content) -> some View {
    content
      .onGeometryChange(for: CGSize.self) { proxy in
        return proxy.size
      } action: { newValue in
        sizeOutput(newValue)
      }
  }
}
extension View {
  public func viewSize(sizeOutput: @escaping ViewSizeOutput) -> some View {
    self.modifier(ViewSizeModifier(sizeOutput: sizeOutput))
  }
}

/// `CGFloat`, for just width, or just height
public struct ViewLengthModifier: ViewModifier {

  let axis: Axis
  let lengthOutput: ViewLengthOutput
  public func body(content: Content) -> some View {
    content
      .onGeometryChange(for: CGFloat.self) { proxy in
        switch axis {
          case .horizontal:
            return proxy.size.width

          case .vertical:
            return proxy.size.height
        }
      } action: { newValue in
        lengthOutput(newValue)
      }
  }
}
extension View {
  public func viewLength(
    _ axis: Axis = .horizontal,
    lengthOutput: @escaping ViewLengthOutput
  ) -> some View {
    self.modifier(ViewLengthModifier(axis: axis, lengthOutput: lengthOutput))
  }
}
