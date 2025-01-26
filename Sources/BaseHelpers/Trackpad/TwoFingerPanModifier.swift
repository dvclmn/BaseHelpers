//
//  PanModifier.swift
//  LilyPad
//
//  Created by Dave Coleman on 6/12/2024.
//

#if canImport(AppKit)

import SwiftUI

public struct TwoFingerPanModifier: ViewModifier {
  
  @Binding var panAmount: CGPoint
  @State private var panDelta: CGPoint = .zero
  @State private var isCurrentlyPanning: Bool = false

  @State private var monitor: Any?
  
  let sensitivity: CGFloat
  let isPanning: (Bool) -> Void

  public init(
    panAmount: Binding<CGPoint>,
    sensitivity: CGFloat,
    isPanning: @escaping (Bool) -> Void
  ) {
    self._panAmount = panAmount
    self.sensitivity = sensitivity
    self.isPanning = isPanning
  }
  
  public func body(content: Content) -> some View {
    content
      .onAppear {
        monitor = NSEvent.addLocalMonitorForEvents(matching: .scrollWheel) { event in
          guard !event.scrollingDeltaX.isNaN && !event.scrollingDeltaY.isNaN else {
            return event
          }
          
          // Check phase changes
          switch event.phase {
            case .began:
              if !isCurrentlyPanning {
                isCurrentlyPanning = true
                isPanning(true)
              }
            case .ended, .cancelled:
              if isCurrentlyPanning {
                isCurrentlyPanning = false
                isPanning(false)
              }
            default:
              break
          }
          
          /// Update delta
          panDelta = CGPoint(
            x: event.scrollingDeltaX * sensitivity,
            y: event.scrollingDeltaY * sensitivity
          )
          
          /// Update total
          panAmount = CGPoint(
            x: panAmount.x + panDelta.x,
            y: panAmount.y + panDelta.y
          )
          
          return event
        }
      }
      .onDisappear {
        if let monitor = monitor {
          NSEvent.removeMonitor(monitor)
        }
        /// Reset the panning state when the view disappears
        if isCurrentlyPanning {
          isCurrentlyPanning = false
          isPanning(false)
        }
      }
  }
}


extension View {
  public func panTrackpadGesture(
    _ panAmount: Binding<CGPoint>,
    sensitivity: CGFloat = 0.8,
    isPanning: @escaping (Bool) -> Void = { _ in }
  ) -> some View {
    self.modifier(
      TwoFingerPanModifier(
        panAmount: panAmount,
        sensitivity: sensitivity,
        isPanning: isPanning
      )
    )
  }
}
#endif
