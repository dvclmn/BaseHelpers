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

//  var pointWasNudged: Bool {
//    offsetPoint(point) > .zero
//  }

  var nearbyPoint: UnitPoint? {
    guard let point else { return nil }
    return point.nearestAnchor(in: containerSize, centerTolerance: 0.9)
  }

  private var edgeBasedOffset: CGSize {

    guard let nearbyPoint, nearbyPoint != UnitPoint.center else { return .zero }
    let offset = nearbyPoint.offset(by: 80)
//    let nudged = point + offset
//    let nudged = nearbyPoint.applyOffset { axis in
//      axis == .horizontal ? 10 : 40
//    } apply: { dx, dy in
//      CGPoint(x: point.x + dx, y: point.y + dy)
//    }

    return offset
  }

  @ViewBuilder
  func DebugCircle(_ point: CGPoint) -> some View {
    Circle()
      .fill(.brown)
      .frame(width: circleRadius, height: circleRadius)
      .overlay {
        Text(point.displayString)
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
