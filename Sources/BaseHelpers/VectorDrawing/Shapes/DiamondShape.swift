//
//  DiamondShape.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 5/7/2025.
//

import SwiftUI

public struct Diamond: Shape {
  public init() {}
  public func path(in rect: CGRect) -> Path {
    var path = Path()
    
    let centerX = rect.midX
    let centerY = rect.midY
    
    // Start from the middle-right point
    path.move(to: CGPoint(x: rect.maxX, y: centerY))
    
    // Draw to the middle-bottom point
    path.addLine(to: CGPoint(x: centerX, y: rect.maxY))
    
    // Draw to the middle-left point
    path.addLine(to: CGPoint(x: rect.minX, y: centerY))
    
    // Draw to the middle-top point
    path.addLine(to: CGPoint(x: centerX, y: rect.minY))
    
    // Close the path back to the middle-right point
    path.closeSubpath()
    
    return path
  }
}
