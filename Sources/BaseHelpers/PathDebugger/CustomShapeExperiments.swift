//
//  CustomBubbleShape.swift
//  Components
//
//  Created by Dave Coleman on 30/9/2024.
//

import SwiftUI

struct ContinuousRoundedRectangle: InsettableShape {
  var cornerRadius: CGFloat
  var style: RoundedCornerStyle
  var insetAmount: CGFloat = 0
  
  init(cornerRadius: CGFloat, style: RoundedCornerStyle = .circular) {
    self.cornerRadius = cornerRadius
    self.style = style
  }
  
  func path(in rect: CGRect) -> Path {
    let rect = rect.insetBy(dx: insetAmount, dy: insetAmount)
    var path = Path()
    
    if style == .circular {
      path = Path(roundedRect: rect, cornerRadius: cornerRadius)
    } else {
      // Continuous corner style
      let radius = min(cornerRadius, min(rect.width, rect.height) / 2)
      let smoothness: CGFloat = 0.62 // Approximation of continuous corner smoothness
      
      path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
      
      // Top edge
      path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
      
      // Top-right corner
      path.addCurve(
        to: CGPoint(x: rect.maxX, y: rect.minY + radius),
        control1: CGPoint(x: rect.maxX - radius * smoothness, y: rect.minY),
        control2: CGPoint(x: rect.maxX, y: rect.minY + radius * smoothness)
      )
      
      // Right edge
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
      
      // Bottom-right corner
      path.addCurve(
        to: CGPoint(x: rect.maxX - radius, y: rect.maxY),
        control1: CGPoint(x: rect.maxX, y: rect.maxY - radius * smoothness),
        control2: CGPoint(x: rect.maxX - radius * smoothness, y: rect.maxY)
      )
      
      // Bottom edge
      path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
      
      // Bottom-left corner
      path.addCurve(
        to: CGPoint(x: rect.minX, y: rect.maxY - radius),
        control1: CGPoint(x: rect.minX + radius * smoothness, y: rect.maxY),
        control2: CGPoint(x: rect.minX, y: rect.maxY - radius * smoothness)
      )
      
      // Left edge
      path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
      
      // Top-left corner
      path.addCurve(
        to: CGPoint(x: rect.minX + radius, y: rect.minY),
        control1: CGPoint(x: rect.minX, y: rect.minY + radius * smoothness),
        control2: CGPoint(x: rect.minX + radius * smoothness, y: rect.minY)
      )
      
      path.closeSubpath()
    }
    
    return path
  }
  
  func inset(by amount: CGFloat) -> some InsettableShape {
    var shape = self
    shape.insetAmount += amount
    return shape
  }
}


struct TestBubbleShape: InsettableShape {
  var cornerRadius: CGFloat = 20
  var arrowHeight: CGFloat = 20
  var arrowWidth: CGFloat = 30
  var arrowPosition: CGFloat = 0.5 // 0 to 1, represents position along the bottom edge
  var insetAmount: CGFloat = 0
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    // Adjust rect for inset
    let rect = rect.insetBy(dx: insetAmount, dy: insetAmount)
    
    
    /// https://stackoverflow.com/a/78497329
    let doubleSideLen = ((rect.width * rect.width) + (rect.height * rect.height)).squareRoot()
    let xOffset = cornerRadius * (rect.width / doubleSideLen)
    let yOffset = cornerRadius * (rect.height / doubleSideLen)
    
    var x = rect.midX - xOffset
    var y = rect.minY + yOffset
    
    
    path.move(to: CGPoint(x: x, y: y))
    x += (2 * xOffset)
    path.addQuadCurve(to: CGPoint(x: x, y: y), control: CGPoint(x: rect.midX, y: rect.minY))
    x = rect.maxX - xOffset
    y = rect.midY - yOffset
    path.addLine(to: CGPoint(x: x, y: y))
    y += (2 * yOffset)
    path.addQuadCurve(to: CGPoint(x: x, y: y), control: CGPoint(x: rect.maxX, y: rect.midY))
    x = rect.midX + xOffset
    y = rect.maxY - yOffset
    path.addLine(to: CGPoint(x: x, y: y))
    x -= (2 * xOffset)
    path.addQuadCurve(to: CGPoint(x: x, y: y), control: CGPoint(x: rect.midX, y: rect.maxY))
    x = rect.minX + xOffset
    y = rect.midY + yOffset
    path.addLine(to: CGPoint(x: x, y: y))
    y -= (2 * yOffset)
    path.addQuadCurve(to: CGPoint(x: x, y: y), control: CGPoint(x: rect.minX, y: rect.midY))
    
    
    
    
    
    
    
    // Calculate arrow points
    let arrowLeftX = rect.minX + (rect.width * arrowPosition) - (arrowWidth / 2)
    let arrowRightX = arrowLeftX + arrowWidth
    let arrowTipY = rect.maxY + arrowHeight
    
    // Start from the bottom-left corner
    path.move(to: CGPoint(x: rect.minX, y: rect.maxY - cornerRadius))
    
    // Bottom edge with arrow
    path.addLine(to: CGPoint(x: arrowLeftX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.minX + (rect.width * arrowPosition), y: arrowTipY))
    path.addLine(to: CGPoint(x: arrowRightX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY))
    
    // Right edge
    path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                radius: cornerRadius,
                startAngle: .degrees(90),
                endAngle: .degrees(0),
                clockwise: false)
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius))
    
    // Top edge
    path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
                radius: cornerRadius,
                startAngle: .degrees(0),
                endAngle: .degrees(-90),
                clockwise: false)
    path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY))
    
    // Left edge
    path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
                radius: cornerRadius,
                startAngle: .degrees(-90),
                endAngle: .degrees(-180),
                clockwise: false)
    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - cornerRadius))
    
    // Close the path
    path.closeSubpath()
    
    return path
  }
  
  func inset(by amount: CGFloat) -> some InsettableShape {
    var shape = self
    shape.insetAmount += amount
    return shape
  }
}



