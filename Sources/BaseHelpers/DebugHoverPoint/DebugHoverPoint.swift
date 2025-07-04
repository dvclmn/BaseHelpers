//
//  DebugHoverPoint.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/7/2025.
//

import SwiftUI

public struct DebugHoverPointModifier: ViewModifier {

  let point: CGPoint?
  public func body(content: Content) -> some View {
    content
      .overlay {
        if let point {
          DebugHoverPointView(point: point)
            .allowsHitTesting(false)
        }
      }
  }
}
extension View {
  public func debugHoverPoint(_ point: CGPoint?) -> some View {
    self.modifier(DebugHoverPointModifier(point: point))
  }
}

public struct DebugHoverPointView: View {

  let point: CGPoint
  private let circleRadius: CGFloat = 18
  public var body: some View {

    Circle()
      .fill(.brown)
      .frame(width: circleRadius, height: circleRadius)
      .overlay {
        Text(point.displayString)
          .font(.caption.weight(.semibold))
          .foregroundStyle(.secondary)
          .fixedSize()
          .padding(4)
          .background(.thinMaterial)
          .clipShape(.rect(cornerRadius: 3))
          .offset(y: -circleRadius * 2)
      }
      .position(point)

  }
}
#if DEBUG
#Preview {
  DebugHoverPointView(point: CGPoint.quickPreset01)
}
#endif
