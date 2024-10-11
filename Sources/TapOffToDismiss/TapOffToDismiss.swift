//
//  File.swift
//
//
//  Created by Dave Coleman on 4/7/2024.
//

import Foundation
import SwiftUI
import Dependencies
import Geometry
import BaseHelpers

#if os(macOS)

/// This should be placed somewhere in `ContentView`, that will allow full coverage of the window.
///
/// Views that want to use this should be placed *above* this modifier, so they're not covered up by it.
///
public struct TapOffToDismiss: ViewModifier {
  
  let isPresented: Bool
  let action: () -> Void
  
  public func body(content: Content) -> some View {
    
    content
      .overlay {
        if isPresented {
//          Color.clear
                Color.blue.opacity(0.6)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
              print("Tapped on the dismiss area")
              action()
            }

        } // END is presented check
      } // END overlay
  }
}
public extension View {
  func tapOffToDismiss(
    isPresented: Bool,
    action: @escaping () -> Void
  ) -> some View {
    self.modifier(
      TapOffToDismiss(
        isPresented: isPresented,
        action: action
      )
    )
  }
}
#endif
