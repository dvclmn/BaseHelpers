//
//  PanRepresentable.swift
//  Paperbark
//
//  Created by Dave Coleman on 24/6/2025.
//

#if canImport(AppKit)
import SwiftUI

public typealias PanGestureOutput = (PanPhase) -> Void

// MARK: - SwiftUI Representable
public struct PanGestureView: NSViewRepresentable {
  let onPanGesture: PanGestureOutput

  public init(onPanGesture: @escaping PanGestureOutput) {
    self.onPanGesture = onPanGesture
  }

  public func makeNSView(context: Context) -> PanTrackingNSView {
    let view = PanTrackingNSView { panOutput in
      onPanGesture(panOutput)
    }

    return view
  }

  public func updateNSView(_ nsView: PanTrackingNSView, context: Context) {
  }
}
#endif
