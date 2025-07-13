//
//  SpaceTransform.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 13/7/2025.
//

import SwiftUI

public enum OriginReference {
  /// Origin is top-left (like GeometryReader)
  case topLeft
  
  /// Origin is the centre of the space (like .position() or CALayer anchor)
  case centre
}


public struct SpaceTransform {
  public var scale: CGFloat
  public var rotation: Angle
  public var translation: CGPoint
  public var originReference: OriginReference
  public var size: CGSize  // Needed to compute centre offset
  
  public init(
    scale: CGFloat = 1.0,
    rotation: Angle = .zero,
    translation: CGPoint = .zero,
    originReference: OriginReference,
    size: CGSize
  ) {
    self.scale = scale
    self.rotation = rotation
    self.translation = translation
    self.originReference = originReference
    self.size = size
  }
//  public init(
//    scale: CGFloat = 1.0,
//    rotation: Angle = .zero,
//    translation: CGPoint = .zero
//  ) {
//    self.scale = scale
//    self.rotation = rotation
//    self.translation = translation
//  }
  
  public func apply(to point: CGPoint) -> CGPoint {
    var p = point
    
    /// Step 1: adjust for origin reference
    switch originReference {
      case .topLeft:
        break
      case .centre:
        // Move point relative to the centre
        let centre = CGPoint(x: size.width / 2, y: size.height / 2)
        p -= centre
    }
    
    /// Step 2: apply scale
    p = p * (1 / scale)
    
    /// Step 3: apply rotation
    if rotation != .zero {
      let radians = rotation.radians
      let s = sin(radians)
      let c = cos(radians)
      p = CGPoint(
        x: p.x * c - p.y * s,
        y: p.x * s + p.y * c
      )
    }
    
    /// Step 4: apply translation
    p -= translation
    
    return p
    
//    /// Translate
//    p.x -= translation.x
//    p.y -= translation.y
//    
//    /// Rotate
//    let radians = rotation.radians
//    let s = sin(radians)
//    let c = cos(radians)
//    let xRot = p.x * c - p.y * s
//    let yRot = p.x * s + p.y * c
//    p = CGPoint(x: xRot, y: yRot)
//    
//    /// Scale
//    p.x /= scale
//    p.y /= scale
//    
//    return p
  }
  
  public func concatenated(with other: SpaceTransform) -> SpaceTransform {
    // Compose scale, rotation, translation
    
    let combinedScale = self.scale * other.scale
    let combinedRotation = self.rotation + other.rotation
    
    // Compose translations (this is slightly naive and assumes no rotation/scale interactions)
    let combinedTranslation = self.translation + other.translation
    
    return SpaceTransform(
      scale: combinedScale,
      rotation: combinedRotation,
      translation: combinedTranslation,
      originReference: .topLeft, // or `.centre`, depending on your pipeline needs
      size: size // choose which size is appropriate to carry forward
    )
  }
  
  public func transform(rect: CGRect) -> CGRect {
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
  
  public func inverted() -> SpaceTransform {
    /// Invert scale: 2 → 0.5
    let invertedScale = 1 / scale
    
    /// Invert rotation: 45º → -45º
    let invertedRotation = Angle(radians: -rotation.radians)
    
    /// Invert translation *after* accounting for rotation and scale
    /// We undo the transform effect on the origin
    var inverse = SpaceTransform(
      scale: invertedScale,
      rotation: invertedRotation,
      translation: .zero,
      originReference: self.originReference,
      size: self.size
    )
    
    /// Apply forward transform to origin to see where it ended up
    /// Then compute translation to undo that
    let transformedOrigin = self.apply(to: .zero)
    let invertedTranslation = CGPoint(x: -transformedOrigin.x, y: -transformedOrigin.y)
    
    inverse.translation = invertedTranslation
    
    return inverse
  }
}
