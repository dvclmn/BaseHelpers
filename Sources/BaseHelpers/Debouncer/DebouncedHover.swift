//
//  DebouncedHover.swift
//  Collection
//
//  Created by Dave Coleman on 22/9/2024.
//

import SwiftUI

public struct DebouncedHoverViewModifier: ViewModifier {
  @State private var isHovering = false
  let interval: TimeInterval
  let onHoverChange: (Bool) -> Void

  public init(interval: TimeInterval, onHoverChange: @escaping (Bool) -> Void) {
    self.interval = interval
    self.onHoverChange = onHoverChange
  }

  public func body(content: Content) -> some View {
    content
      .onHover { hovering in
        isHovering = hovering
        Task {
          do {
            try await Task.sleep(for: .seconds(interval))
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
    interval: TimeInterval = 0.2, perform action: @escaping (Bool) -> Void
  ) -> some View {
    modifier(DebouncedHoverViewModifier(interval: interval, onHoverChange: action))
  }
}
