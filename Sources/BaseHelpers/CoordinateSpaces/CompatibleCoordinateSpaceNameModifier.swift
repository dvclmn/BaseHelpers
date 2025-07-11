//
//  CoordinateSpace.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/7/2025.
//

import SwiftUI

public struct CompatibleCoordinateSpaceNameModifier: ViewModifier {
  
  let name: AnyHashable
  public func body(content: Content) -> some View {
    
    if #available(macOS 15, iOS 18, *) {
      content
        .coordinateSpace(.named(name))
    } else {
      content
        .coordinateSpace(name: name)
    }
  }
}
extension View {
  public func setCoordinateSpaceName<T: Hashable>(_ name: T) -> some View {
    self.modifier(CompatibleCoordinateSpaceNameModifier(name: name))
  }
}
