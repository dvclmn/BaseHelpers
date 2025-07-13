//
//  SpaceTransform.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 13/7/2025.
//

import SwiftUI

struct SpaceTransform {
  var scale: CGFloat = 1
  var rotation: Angle = .zero
  var translation: CGPoint = .zero
  
  func apply(to point: CGPoint) -> CGPoint {
    var p = point
    
    /// Translate
    p.x -= translation.x
    p.y -= translation.y
    
    /// Rotate
    let radians = rotation.radians
    let s = sin(radians)
    let c = cos(radians)
    let xRot = p.x * c - p.y * s
    let yRot = p.x * s + p.y * c
    p = CGPoint(x: xRot, y: yRot)
    
    /// Scale
    p.x /= scale
    p.y /= scale
    
    return p
  }
  
  func transform(rect: CGRect) -> CGRect {
    /// Optional: apply transform to each corner, then compute bounds
    let corners = [
      CGPoint(x: rect.minX, y: rect.minY),
      CGPoint(x: rect.maxX, y: rect.minY),
      CGPoint(x: rect.maxX, y: rect.maxY),
      CGPoint(x: rect.minX, y: rect.maxY),
    ]
    let transformedCorners = corners.map { apply(to: $0) }
    let xs = transformedCorners.map { $0.x }
    let ys = transformedCorners.map { $0.y }
    return CGRect(
      x: xs.min() ?? 0,
      y: ys.min() ?? 0,
      width: (xs.max() ?? 0) - (xs.min() ?? 0),
      height: (ys.max() ?? 0) - (ys.min() ?? 0)
    )
  }
  
  func inverted() -> SpaceTransform {
    /// Invert scale: 2 → 0.5
    let invertedScale = 1 / scale
    
    /// Invert rotation: 45º → -45º
    let invertedRotation = Angle(radians: -rotation.radians)
    
    /// Invert translation *after* accounting for rotation and scale
    /// We undo the transform effect on the origin
    var inverse = SpaceTransform(scale: invertedScale, rotation: invertedRotation, translation: .zero)
    
    /// Apply forward transform to origin to see where it ended up
    /// Then compute translation to undo that
    let transformedOrigin = self.apply(to: .zero)
    let invertedTranslation = CGPoint(x: -transformedOrigin.x, y: -transformedOrigin.y)
    
    inverse.translation = invertedTranslation
    
    return inverse
  }
}
