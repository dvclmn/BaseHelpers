//
//  Compat+MixColour.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 20/9/2025.
//

import SwiftUI

extension ShapeStyle where Self == Color {
  public func mixCompatible(
    with rhs: Self,
    by fraction: Double,
    in colorSpace: Gradient.ColorSpace = .perceptual
  ) -> Self {
    guard #available(macOS 15, iOS 18, *) else {
      return self
    }
    return self.mix(
      with: rhs,
      by: fraction,
      in: colorSpace
    )
  }

}
