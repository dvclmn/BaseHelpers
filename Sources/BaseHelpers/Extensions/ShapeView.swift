//
//  ShapeView.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 16/3/2025.
//

import SwiftUI

extension ShapeView {
  public func quickStroke<S>(_ colour: S, _ linewidth: CGFloat) -> StrokeShapeView<Self.Content, S, Self>
  where S: ShapeStyle {
    self.stroke(
      colour,
      lineWidth: linewidth,
      antialiased: true
    )
  }

  public func stroke(
    style: AnyShapeStyle?,
    lineWidth: CGFloat?,
  ) -> some View {
    let colour = style ?? AnyShapeStyle(Color.white.opacityMid)
    let strokeWidth = lineWidth ?? 1
    return self.stroke(colour, lineWidth: strokeWidth)
  }
}

extension ShapeView where Self.Content : InsettableShape {
//  public func strokeBorder<S>(_ content: S = .foreground, lineWidth: CGFloat = 1, antialiased: Bool = true) -> StrokeBorderShapeView<Self.Content, S, Self> where S : ShapeStyle
  
  public func strokeBorder(
    style: AnyShapeStyle?,
    lineWidth: CGFloat?,
  ) -> some View {
    let colour = style ?? AnyShapeStyle(Color.white.opacityMid)
    let strokeWidth = lineWidth ?? 1
    return self.stroke(colour, lineWidth: strokeWidth)
  }
}
