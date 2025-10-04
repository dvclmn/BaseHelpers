//
//  Representable.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

#if canImport(AppKit)
import SwiftUI

public typealias TouchOutput = (Set<TouchPoint>) -> Void

// MARK: - SwiftUI Representable
/// SwiftUI wrapper for the trackpad touches view
public struct TrackpadTouchesView: NSViewRepresentable {

  private var onTouchesUpdate: TouchOutput?

  public init(onTouchesUpdate: TouchOutput? = nil) {
    self.onTouchesUpdate = onTouchesUpdate
  }

  public func makeNSView(context: Context) -> TrackpadTouchesNSView {
    let view = TrackpadTouchesNSView { touchOutput in
      onTouchesUpdate?(touchOutput)
    }
    return view
  }

  public func updateNSView(_ nsView: TrackpadTouchesNSView, context: Context) {

  }
}
#endif
