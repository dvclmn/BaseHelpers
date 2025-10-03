//
//  DebugCircle.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 8/7/2025.
//

import SwiftUI

public struct DebugCircleModifier: ViewModifier {

  let location: CGPoint?
  let size: CGFloat
  public func body(content: Content) -> some View {
    content
      .overlay {
        if let location {
          ZStack {
            Circle()
              .fill(.purple)
              .frame(width: size, height: size)

#warning("This shouldn't need a String(describing), need to fix DisplayString stuff")
            Text(String(describing: location.displayString))
            
              .font(.caption)
              .padding(4)
              .background(.thinMaterial)
              .clipShape(.rect(cornerRadius: 3))
              .offset(y: -size * 2)
          }  // END zstack
          .position(location)
        }
      }
  }
}
extension View {
  public func debugCircle(
    _ location: CGPoint?,
    size: CGFloat = 10,
  ) -> some View {
    self.modifier(
      DebugCircleModifier(
        location: location,
        size: size,
      )
    )
  }
}
