//
//  TriangleShape.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 5/7/2025.
//

import SwiftUI



public struct Triangle: Shape, InsettableShape {
  private var insetAmount: CGFloat = 0
  
  public init() {}
  
  public func path(in rect: CGRect) -> Path {
    var path = Path()
    // Start from the bottom-left corner
    path.move(to: CGPoint(x: rect.minX + insetAmount, y: rect.maxY - insetAmount))
    // Draw to the bottom-right corner
    path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.maxY - insetAmount))
    // Draw to the top-center point
    path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + insetAmount))
    // Close the path back to the bottom-left corner
    path.closeSubpath()
    return path
  }
  
  public func inset(by amount: CGFloat) -> some InsettableShape {
    var triangle = self
    triangle.insetAmount = amount
    return triangle
  }
}
