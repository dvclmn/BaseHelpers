////
////  DragAlongAxis.swift
////  BaseHelpers
////
////  Created by Dave Coleman on 16/5/2025.
////
//
//import SwiftUI
//
//public struct ExampleModifier: ViewModifier {
//
//  public func body(content: Content) -> some View {
//    content
//  }
//}
//extension View {
//  public func example() -> some View {
//    self.modifier(ExampleModifier())
//  }
//}
//
//public typealias OnDragChange = (Bool) -> Void
//public typealias DragOutput<DragContent> = (Double) -> DragContent
//
//public struct DragAlongAxisModifier<DragContent: View>: ViewModifier {
//
//
//  @Binding var value: Double
//  @State private var isDragging: Bool = false
//
//  let range: ClosedRange<Double>
//  let axis: Axis
//  let minDragDistance: CGFloat
//  let onDragChange: OnDragChange?
//  let dragContent: DragOutput<DragContent>
//
//  public init(
//    value: Binding<Double>,
//    range: ClosedRange<Double>,
//    axis: Axis = .horizontal,
//    minDragDistance: CGFloat = 0,
//    onDragChange: OnDragChange?,
//    @ViewBuilder dragContent: @escaping DragOutput<DragContent>
//  ) {
//    self._value = value
//    self.range = range
//    self.axis = axis
//    self.minDragDistance = minDragDistance
//    self.onDragChange = onDragChange
//    self.dragContent = dragContent
//  }
//
//  public func body(content: Content) -> some View {
//    ZStack(alignment: .topLeading) {
//      content
//        .contentShape(Rectangle())
//        .gesture(dragGesture)
//
//      //      if let dragContent = dragContent {
//      // Normalize the current value to 0-1 for positioning
//      let normalizedValue = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
//
//      dragContent(value)
//        .offset(
//          x: axis == .horizontal ? normalizedValue * 100 : 0,
//          y: axis == .vertical ? normalizedValue * 100 : 0
//        )
//        .opacity(isDragging ? 1.0 : 0.8)
//        .animation(.spring(), value: isDragging)
//      //      }
//    }
//    .onChange(of: isDragging) { _, newValue in
//      onDragChange?(newValue)
//    }
//  }
//}
//
//extension DragAlongAxisModifier {
//  var dragGesture: some Gesture {
//    DragGesture(minimumDistance: minDragDistance)
//      .onChanged { gestureValue in
//        if !isDragging {
//          isDragging = true
//        }
//
//        let dimension: CGFloat
//        let location: CGFloat
//
//        if axis == .horizontal {
//          dimension = gestureValue.startLocation.x + gestureValue.translation.width
//          location = gestureValue.location.x
//        } else {
//          dimension = gestureValue.startLocation.y + gestureValue.translation.height
//          location = gestureValue.location.y
//        }
//
//        let clamped = max(0, min(location, dimension))
//        let percentage = dimension == 0 ? 0 : clamped / dimension
//
//        // Calculate the new value based on the range and percentage
//        let newValue = range.lowerBound + percentage * (range.upperBound - range.lowerBound)
//
//        // Update the value binding
//        value = newValue.clamped(to: range)
//      }
//      .onEnded { _ in
//        isDragging = false
//      }
//  }
//}
//
//extension View {
//  public func dragAlongAxis<DragContent: View>(
//    value: Binding<Double>,
//    range: ClosedRange<Double>,
//    axis: Axis = .horizontal,
//    minDragDistance: CGFloat = 0,
//    onDragChange: OnDragChange? = nil,
//    @ViewBuilder dragContent: @escaping DragOutput<DragContent>
//  ) -> some View {
//    self.modifier(
//      DragAlongAxisModifier(
//        value: value,
//        range: range,
//        axis: axis,
//        minDragDistance: minDragDistance,
//        onDragChange: onDragChange,
//        dragContent: dragContent
//      )
//    )
//  }
//
////  public func dragAlongAxis(
////    value: Binding<Double>,
////    range: ClosedRange<Double>,
////    axis: Axis = .horizontal,
////    minDragDistance: CGFloat = 0,
////    onDragChange: OnDragChange? = nil
////  ) -> some View {
////    self.modifier(
////      DragAlongAxisModifier<EmptyView>(
////        value: value,
////        range: range,
////        axis: axis,
////        minDragDistance: minDragDistance,
////        onDragChange: onDragChange,
////        dragContent: nil
////      )
////    )
////  }
//}
//
////// Helper extension to clamp values to a range
////extension Comparable {
////  func clamped(to range: ClosedRange<Self>) -> Self {
////    return min(max(self, range.lowerBound), range.upperBound)
////  }
////}
