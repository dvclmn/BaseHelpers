//
//  File.swift
//
//
//  Created by Dave Coleman on 25/4/2024.
//

import Foundation
import SwiftUI

// MARK: - Grain overlay
public struct GrainOverlay: ViewModifier {
  var opacity: Double
  
  public func body(content: Content) -> some View {
    content
      .overlay(
        Image("fuji", bundle: .module)
          .resizable(resizingMode: .tile)
          .drawingGroup()
          .blendMode(.overlay)
          .opacity(opacity)
          .allowsHitTesting(false)
          .ignoresSafeArea()
      )
    
  }
}
public extension View {
  func grainOverlay(
    opacity: Double = 0.4
  ) -> some View {
    self.modifier(
      GrainOverlay(
        opacity: opacity
      )
    )
  }
}
