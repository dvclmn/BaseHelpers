//
//  ZoomModifier.swift
//  Collection
//
//  Created by Dave Coleman on 8/12/2024.
//

import SwiftUI

public struct ZoomGestureModifier: ViewModifier {
  
//  @Binding var panAmount: CGPoint
//  @State private var panDelta: CGPoint = .zero
//  @State private var monitor: Any?
  
  @GestureState private var magnifyBy = 1.0
  
  let sensitivity: CGFloat
  
  public init(
//    panAmount: Binding<CGPoint>,
    sensitivity: CGFloat = 0.8
  ) {
//    self._panAmount = panAmount
    self.sensitivity = sensitivity
  }
  public func body(content: Content) -> some View {
    content
      .gesture(magnifyGesture)

  }
}
extension ZoomGestureModifier {
  
  var magnifyGesture: some Gesture {
    MagnifyGesture()
      .updating($magnifyBy) { value, gestureState, transaction in
        print("""
        
        
        Value: \(value)
        GestureState: \(gestureState)
        Transaction: \(transaction)
        
        
        """)
        gestureState = value.magnification
      }
  }
  
  //  func handleZoom(_ currentDistance: CGFloat) {
  //    if let previousDistance = previousTouchDistance {
  //      let delta = (currentDistance - previousDistance) / previousDistance
  //      let smoothedDelta = smoothValue(delta, deltas: &recentZoomDeltas)
  //      updateGesture(.zoom, delta: smoothedDelta)
  //    }
  //  }
  
  //  func handleZoomFromTouches(_ touches: [NSTouch]) {
  //    guard touches.count == 2 else { return }
  //
  //    let touch1 = touches[0].normalizedPosition
  //    let touch2 = touches[1].normalizedPosition
  //
  //    /// Calculate current distance between touches
  //    let currentDistance = hypot(
  //      touch2.x - touch1.x,
  //      touch2.y - touch1.y
  //    )
  //
  //    if let previousTouchDistance {
  //      var delta = (currentDistance - previousTouchDistance) / previousTouchDistance
  //
  //      /// Apply dampening for small changes
  //      //      let dampThreshold: CGFloat = 0.01
  //      //      if abs(delta) < dampThreshold {
  //      //        delta = 0
  //      //      }
  //
  //      updateGesture(.zoom, delta: delta)
  //    }
  //
  //    previousTouchDistance = currentDistance
  //  }
}
//public extension View {
//  func example(
//  ) -> some View {
//    self.modifier(
//      ExampleModifier(
//      )
//    )
//  }
//}
