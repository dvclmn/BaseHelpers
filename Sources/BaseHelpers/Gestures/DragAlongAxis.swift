//
//  DragAlongAxis.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 16/5/2025.
//

import SwiftUI

public struct DragAlongAxisModifier: ViewModifier {
  
  @Binding var value: Double
  
  /// Should be able to normalise the range against the width?
  let range: ClosedRange<Double>
  let width: CGFloat
  let minDragDistance: CGFloat
  
  // Future?: let isDragging: (Bool) -> Void
  /// This could be a View that is moved along with the drag gesture
  // Also future: let draggedContent: Content -> Void
  
  public func body(content: Content) -> some View {
    content
  }
}
extension DragAlongAxisModifier {
  var dragGesture: some Gesture {
    
    return DragGesture(minimumDistance: 0)
//      .updating($isDragging) { _, isDragging, _ in
//        isDragging = true
//      }
      .onChanged { gestureValue in
        let location = gestureValue.location.x
        let clamped = min(max(location, 0), width)
        let percentage = clamped / width
        
        let newValue = range.lowerBound + (percentage * (range.upperBound - range.lowerBound))
        
        value = newValue
      }
      .onEnded { gesture in
        // isDragging = false
      }
  }

}
public extension View {
  func dragAlongAxis() -> some View {
    self.modifier(DragAlongAxisModifier())
  }
}
