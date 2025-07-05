//
//  CrossShape.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 5/7/2025.
//

import SwiftUI

public struct Cross: Shape {
  
  public init() {}
  
  public func path(in rect: CGRect) -> Path {
    var path = Path()
    
    // Calculate line thickness (1/4 of the smaller dimension)
    let thickness = min(rect.width, rect.height) * 0.25
    
    // Horizontal line
    path.addRect(
      CGRect(
        x: rect.minX,
        y: rect.midY - thickness / 2,
        width: rect.width,
        height: thickness
      ))
    
    // Vertical line
    path.addRect(
      CGRect(
        x: rect.midX - thickness / 2,
        y: rect.minY,
        width: thickness,
        height: rect.height
      ))
    
    return path
  }
}
