//
//  ShapeView.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 16/3/2025.
//

import SwiftUI

extension ShapeView {
  public func quickStroke<S>(_ colour: S, _ linewidth: CGFloat) -> StrokeShapeView<Self.Content, S, Self> where S : ShapeStyle {
    self.stroke(
      colour,
      lineWidth: linewidth,
      antialiased: true
    )
  }
}
