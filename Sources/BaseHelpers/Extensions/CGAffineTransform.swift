//
//  CGAffineTransform.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 8/6/2025.
//

import CoreGraphics

extension CGAffineTransform {

  // MARK: - Basic Rotations

  public static func rotation(degrees: CGFloat) -> CGAffineTransform {
    let radians = degrees * (.pi / 180)
    return CGAffineTransform(rotationAngle: radians)
  }

  public static var rotate45: CGAffineTransform {
    .rotation(degrees: 45)
  }

  public static var rotate90: CGAffineTransform {
    .rotation(degrees: 90)
  }

  public static var rotate180: CGAffineTransform {
    .rotation(degrees: 180)
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
