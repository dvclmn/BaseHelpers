//
//  CoordinateSpace.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/7/2025.
//

import SwiftUI

public enum CoordinateSpaceFrame {
  case none
  case visible(Color)
}

public struct CompatibleCoordinateSpaceNameModifier: ViewModifier {

  let name: AnyHashable
  let debugFrame: CoordinateSpaceFrame
  public func body(content: Content) -> some View {

    if #available(macOS 15, iOS 18, *) {
      content
        .border(borderColour)
        .coordinateSpace(.named(name))
    } else {
      content
        .border(borderColour)
        .coordinateSpace(name: name)
    }
  }
}
extension CompatibleCoordinateSpaceNameModifier {
  var borderColour: Color {
    switch debugFrame {
      case .none: return Color.clear
      case .visible(let colour): return colour.opacity(0.3)
    }
  }
}
extension View {
  public func setCoordinateSpaceName<T: Hashable>(
    _ name: T,
    debugFrame: CoordinateSpaceFrame = .none
  ) -> some View {
    self.modifier(CompatibleCoordinateSpaceNameModifier(name: name, debugFrame: debugFrame))
  }
}
