//
//  File.swift
//
//
//  Created by Dave Coleman on 4/6/2024.
//

import Foundation
import SwiftUI

public struct AsymmetricalHoverEffect: ViewModifier {
  
  var inSpeed: Double
  var outSpeed: Double
  
  var isHovering: (Bool) -> Void
  
  public func body(content: Content) -> some View {
    content
      .onHover { hovering in
        
        if hovering {
          withAnimation(.easeOut(duration: inSpeed)) {
            isHovering(true)
          }
        } else {
          withAnimation(.easeInOut(duration: outSpeed)) {
            isHovering(false)
          }
        }
        
      }
  }
}
public extension View {
  func hoverAsync(
    inSpeed: Double = 0.08,
    outSpeed: Double = 0.4,
    isHovering: @escaping (Bool) -> Void
  ) -> some View {
    modifier(
      AsymmetricalHoverEffect(
        inSpeed: inSpeed,
        outSpeed: outSpeed,
        isHovering: isHovering
      )
    )
  }
}
