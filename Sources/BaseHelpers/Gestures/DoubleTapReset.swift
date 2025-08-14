//
//  SimpleSliderModifier.swift
//  Components
//
//  Created by Dave Coleman on 17/11/2024.
//

import SwiftUI

public struct DoubleTapModifier: ViewModifier {
  
//  @Binding var value: Double
//  let defaultValue: Double?
  
  private let action: () -> Void
  
  /// For backwards compatibility
  public init(value: Binding<Double>, defaultValue: Double?) {
    self.action = {
      if let defaultValue {
        print("Double tapped to reset to default value: \(defaultValue)")
        value.wrappedValue = defaultValue
      } else {
        print("Double tapped, but no default value set.")
      }
    }
  }
  
  // New flexible option
  public init(action: @escaping () -> Void) {
    self.action = action
  }
  
  public func body(content: Content) -> some View {
    content
      .gesture(
        TapGesture(count: 2)
          .onEnded { _ in
            action()
          }
      )
  }
  
//  public func body(content: Content) -> some View {
//    content
//      .gesture(
//        TapGesture(count: 2)
//          .onEnded { _ in
//            if let defaultValue {
//              print("Double tapped to reset to default value: \(defaultValue)")
//              value = defaultValue
//            } else {
//              print("Double tapped, but no default value set.")
//            }
//          }
//      )
//  }
}
extension View {
  
  public func onDoubleTap(
    _ value: Binding<Double>,
    defaultValue: Double? = nil
  ) -> some View {
    self.modifier(DoubleTapModifier(value: value, defaultValue: defaultValue))
  }
  
  public func onDoubleTap(
    _ action: @escaping () -> Void
  ) -> some View {
    self.modifier(DoubleTapModifier(action: action))
  }
  
  
//  public func onDoubleTap(
//    _ value: Binding<Double>,
//    defaultValue: Double?
//  ) -> some View {
//    self.modifier(
//      DoubleTapModifier(
//        value: value,
//        defaultValue: defaultValue
//      )
//    )
//  }
}
