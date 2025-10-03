//
//  DebugHoverPoint.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/7/2025.
//

import SwiftUI

public struct DebugHoverPointModifier: ViewModifier {

  let point: CGPoint?
  let containerSize: CGSize
  private let circleRadius: CGFloat = 18

  public func body(content: Content) -> some View {
    content
      .overlay {
        if let point {
          DebugCircle(point)
        }
      }
  }
}
extension DebugHoverPointModifier {

  var nearbyPoint: UnitPoint? {
    guard let point else { return nil }
    return point.nearestAnchor(in: containerSize, centerTolerance: 0.9)
  }

  private var edgeBasedOffset: CGSize {
    guard let nearbyPoint, nearbyPoint != UnitPoint.center else { return .zero }
    let offset = nearbyPoint.offset(by: 80)
    return offset
  }

  @ViewBuilder
  func DebugCircle(_ point: CGPoint) -> some View {
    Circle()
      .fill(.brown)
      .frame(width: circleRadius, height: circleRadius)
      .overlay {
        #warning("This shouldn't need a String(describing), need to fix DisplayString stuff")
        Text(String(describing: point.displayString))
          .font(.caption.weight(.semibold))
          .monospaced()
          .foregroundStyle(.secondary)
          .fixedSize()
          .padding(4)
          .background(.thinMaterial)
          .clipShape(.rect(cornerRadius: 3))
          .offset(y: -circleRadius * 2)
          .offset(edgeBasedOffset)
        //          .offset(pointWasNudged ? offsetPoint(point) : .zero)
        //          .animation(.spring, value: edgeBasedOffset)
        //          .animation(.spring, value: pointWasNudged)
      }
      .position(point)
      .allowsHitTesting(false)
  }
}
extension View {
  public func debugHoverPoint(_ point: CGPoint?, containerSize: CGSize) -> some View {
    self.modifier(DebugHoverPointModifier(point: point, containerSize: containerSize))
  }
}
