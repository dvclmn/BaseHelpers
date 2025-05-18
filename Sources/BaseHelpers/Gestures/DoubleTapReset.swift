//
//  SimpleSliderModifier.swift
//  Components
//
//  Created by Dave Coleman on 17/11/2024.
//

import SwiftUI

public struct DoubleTapModifier: ViewModifier {
  
  @Binding var value: Double
  let defaultValue: Double?
  
  public func body(content: Content) -> some View {
    content
      .gesture(
        TapGesture(count: 2)
          .onEnded { _ in
            if let defaultValue {
              print("Double tapped to reset to default value: \(defaultValue)")
              value = defaultValue
            } else {
              print("Double tapped, but no default value set.")
            }
          }
      )
  }
}
extension View {
  public func doubleTap(
    _ value: Binding<Double>,
    defaultValue: Double?
  ) -> some View {
    self.modifier(
      DoubleTapModifier(
        value: value,
        defaultValue: defaultValue
      )
    )
  }
}
