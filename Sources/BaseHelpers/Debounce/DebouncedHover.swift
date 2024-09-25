//
//  DebouncedHover.swift
//  Collection
//
//  Created by Dave Coleman on 22/9/2024.
//

import SwiftUI

public struct DebouncedHoverViewModifier: ViewModifier {
  @State private var isHovering = false
  let seconds: TimeInterval
  let onHoverChange: (Bool) -> Void
  
  public init(seconds: TimeInterval, onHoverChange: @escaping (Bool) -> Void) {
    self.seconds = seconds
    self.onHoverChange = onHoverChange
  }
  
  public func body(content: Content) -> some View {
    content
      .onHover { hovering in
        isHovering = hovering
        Task {
          do {
            try await Task.sleep(for: .seconds(seconds))
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

public extension View {
  func debouncedHover(seconds: TimeInterval = 0.2, perform action: @escaping (Bool) -> Void) -> some View {
    modifier(DebouncedHoverViewModifier(seconds: seconds, onHoverChange: action))
  }
}
