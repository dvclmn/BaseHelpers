//
//  CGAffineTransform.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 8/6/2025.
//

import CoreGraphics

extension CGAffineTransform {

  public var hasTranslation: Bool {
    return tx != 0 || ty != 0
  }

  public var hasScale: Bool {
    let scaleX = sqrt(a * a + c * c)
    let scaleY = sqrt(b * b + d * d)
    return abs(scaleX - 1.0) > 0.001 || abs(scaleY - 1.0) > 0.001
  }

  public var hasRotation: Bool {
    // Check if the transform has rotation by seeing if it's not axis-aligned
    return abs(b) > 0.001 || abs(c) > 0.001
  }

  public var rotationAngle: CGFloat {
    return atan2(b, a)
  }

  public var scaleX: CGFloat {
    return sqrt(a * a + c * c)
  }

  public var scaleY: CGFloat {
    return sqrt(b * b + d * d)
  }
  
  


  //  var isRotated: Bool {
  //    return rotation
  //  }
  //
  //  var rotation: Double {
  //    return atan2(Double(self.b), Double(self.a))
  //  }

  // MARK: - Basic Rotations
  public static func rotate(degrees: CGFloat) -> CGAffineTransform {
    let radians = degrees * (.pi / 180)
    return CGAffineTransform(rotationAngle: radians)
  }

  public static var rotate45: CGAffineTransform {
    .rotate(degrees: 45)
  }

  public static var rotate90: CGAffineTransform {
    .rotate(degrees: 90)
  }

  public static var rotate180: CGAffineTransform {
    .rotate(degrees: 180)
  }

  // MARK: - Scaling

  public static func scale(x: CGFloat, y: CGFloat) -> CGAffineTransform {
    CGAffineTransform(scaleX: x, y: y)
  }

  public static var uniformScale2x: CGAffineTransform {
    .scale(x: 2, y: 2)
  }

  public static var shrinkToHalf: CGAffineTransform {
    .scale(x: 0.5, y: 0.5)
  }

  // MARK: - Shearing

  public static func shear(x shearX: CGFloat, y shearY: CGFloat) -> CGAffineTransform {
    // Shearing is a combination of transformations not provided directly
    // We build the matrix manually:
    CGAffineTransform(
      a: 1, b: shearY,
      c: shearX, d: 1,
      tx: 0, ty: 0)
  }

  public static var shearX10: CGAffineTransform {
    .shear(x: 0.1, y: 0)
  }

  public static var shearY10: CGAffineTransform {
    .shear(x: 0, y: 0.1)
  }

  // MARK: - Translations

  public static func translate(x: CGFloat, y: CGFloat) -> CGAffineTransform {
    CGAffineTransform(translationX: x, y: y)
  }

  public static var moveRight100: CGAffineTransform {
    .translate(x: 100, y: 0)
  }

  public static var moveDown50: CGAffineTransform {
    .translate(x: 0, y: 50)
  }
}
