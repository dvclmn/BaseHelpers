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

  //  @Binding var canvasHandler: CanvasHandler
  ///
  //  let zoom: CGFloat

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

  //  var zoom: CGFloat { canvasHandler.transform.zoom }
  //  var pan: CGSize { canvasHandler.transform.pan }

  func zoomGesture() -> some Gesture {
    MagnifyGesture()
      .updating($magnification) { value, state, _ in
        state = value.magnification
      }
      .onChanged { value in

        //        canvasHandler.interactions.context.gestureType = .zoom
        //        guard let hoverLocation = canvasHandler.hoverLocation else { return }

        if initialZoom == nil {
          initialZoom = zoom
        }
        guard let initialZoom else { return }

        let newZoom = (initialZoom) * value.magnification

        let clampedZoom = newZoom.clamped(to: zoomRange)

        //        let anchorCanvasPositionBefore = CGPoint(
        //          x: (hoverLocation.x - pan.width) / zoom,
        //          y: (hoverLocation.y - pan.height) / zoom
        //        )
        //
        //        let newPan = CGSize(
        //          width: hoverLocation.x - anchorCanvasPositionBefore.x * clampedZoom,
        //          height: hoverLocation.y - anchorCanvasPositionBefore.y * clampedZoom
        //        )

        //        canvasHandler.transform.zoom = clampedZoom
        //        canvasHandler.transform.pan = newPan

        zoom = clampedZoom
        didUpdateZoom(.active(magnification: clampedZoom))
      }
      .onEnded { _ in
        //        canvasHandler.interactions.context.gestureType = .none
        initialZoom = nil
        didUpdateZoom(.ended)
      }
  }
}
extension View {
  public func onZoomGesture(
    //    canvasHandler: Binding<CanvasHandler>,
    zoom: Binding<CGFloat>,
    zoomRange: ClosedRange<CGFloat>,
    isEnabled: Bool = true,
    didUpdateZoom: @escaping (ZoomPhase) -> Void = { _ in }
  ) -> some View {
    self.modifier(
      ZoomViewModifier(
        //        canvasHandler: canvasHandler,
        zoom: zoom,
        zoomRange: zoomRange,
        isEnabled: isEnabled,
        didUpdateZoom: didUpdateZoom
      )
    )
  }
}
