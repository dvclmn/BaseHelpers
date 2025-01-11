// The Swift Programming Language
// https://docs.swift.org/swift-book

//
//  SpinningView.swift
//  Eucalypt
//
//  Created by Dave Coleman on 21/3/2024.
//

import Foundation
import SwiftUI

public struct SpinningView: ViewModifier {

  @State private var isRotating = 0.0

  var isOn: Bool
  let speed: TimeInterval
  
  let totalSpinCount: Int = 5

  public func body(content: Content) -> some View {

    let animation = Animation.linear(duration: speed).repeatCount(totalSpinCount, autoreverses: false)

    content
      .foregroundStyle(.secondary)
      .rotationEffect(.degrees(isRotating))
      .animation(animation, value: isRotating)
      .frame(width: 26)
      .onAppear {
        if isOn {
          isRotating = 360.0
        }
      }
  }
}
extension View {
  public func spinning(
    isOn: Bool = true,
    speed: TimeInterval = 2
  ) -> some View {
    self.modifier(
      SpinningView(
        isOn: isOn,
        speed: speed
      )
    )
  }
}
