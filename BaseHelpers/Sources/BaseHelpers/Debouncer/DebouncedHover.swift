//
//  DebouncedHover.swift
//  Collection
//
//  Created by Dave Coleman on 22/9/2024.
//

import SwiftUI

public struct DebouncedHoverViewModifier: ViewModifier {
  @State private var isHovering = false
  let enterInterval: TimeInterval
  let exitInterval: TimeInterval
  
  let onHoverChange: (Bool) -> Void

//  public init(interval: TimeInterval, onHoverChange: @escaping (Bool) -> Void) {
//    self.interval = interval
//    self.onHoverChange = onHoverChange
//  }

  public func body(content: Content) -> some View {
    content
      .onHover { hovering in
        isHovering = hovering
        Task {
          do {
            let delay = hovering ? enterInterval : exitInterval
            try await Task.sleep(for: .seconds(delay))
            if isHovering == hovering {
              onHoverChange(hovering)
            }
          } catch {
            // Ignore cancellation
          }
        }
      }
  }
}

extension View {
  public func debouncedHover(
    enterInterval: TimeInterval = 0.4,
    exitInterval: TimeInterval = 0.1,
//    interval: TimeInterval = 0.2,
    perform action: @escaping (Bool) -> Void
  ) -> some View {
    modifier(
      DebouncedHoverViewModifier(
        enterInterval: enterInterval,
        exitInterval: exitInterval,
        onHoverChange: action
      )
    )
  }
}
