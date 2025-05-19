//
//  LinearGradient.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/5/2025.
//

import SwiftUI

extension LinearGradient {
  public static func lightFalloff(
    _ colour: Color = .white,
    direction: Alignment = .topLeading,
    fallofAmount: CGFloat = 0.9
  ) -> LinearGradient {
    
    LinearGradient(
      colors: [
        colour,
        colour.opacity(fallofAmount.inversePercentage)
      ],
      startPoint: direction.toUnitPoint,
      endPoint: direction.opposing.toUnitPoint
    )
  }
  
  
}
