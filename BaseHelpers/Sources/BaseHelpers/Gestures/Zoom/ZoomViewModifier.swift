//
//  ZoomViewModifier.swift
//  LilyPad
//
//  Created by Dave Coleman on 24/6/2025.
//

import SwiftUI

public enum ZoomPhase {
  case inactive
  case active(magnification: CGFloat)
  case ended
}

public struct ZoomViewModifier: ViewModifier {

  @GestureState private var magnification: CGFloat = 1

  @State private var initialZoom: CGFloat?

  @Binding var zoom: CGFloat
  let zoomRange: ClosedRange<CGFloat>
  let isEnabled: Bool
  let didUpdateZoom: (ZoomPhase) -> Void

  public func body(content: Content) -> some View {
    content
      .simultaneousGesture(zoomGesture(), isEnabled: isEnabled)
  }
}
extension ZoomViewModifier {

  func zoomGesture() -> some Gesture {
    MagnifyGesture()
      .updating($magnification) { value, state, _ in
        state = value.magnification
      }
      .onChanged { value in

        if initialZoom == nil {
          initialZoom = zoom
        }
        guard let initialZoom else { return }

        let newZoom = (initialZoom) * value.magnification
        let clampedZoom = newZoom.clamped(to: zoomRange)

        zoom = clampedZoom
        didUpdateZoom(.active(magnification: clampedZoom))
      }
      .onEnded { _ in
        initialZoom = nil
        didUpdateZoom(.ended)
      }
  }
}
extension View {
  public func onZoomGesture(
    zoom: Binding<CGFloat>,
    zoomRange: ClosedRange<CGFloat>,
    isEnabled: Bool = true,
    didUpdateZoom: @escaping (ZoomPhase) -> Void = { _ in }
  ) -> some View {
    self.modifier(
      ZoomViewModifier(
        zoom: zoom,
        zoomRange: zoomRange,
        isEnabled: isEnabled,
        didUpdateZoom: didUpdateZoom
      )
    )
  }
}
