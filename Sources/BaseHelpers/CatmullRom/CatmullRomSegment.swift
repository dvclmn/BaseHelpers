//
//  CRomSegment.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/5/2025.
//

import Foundation

/// Important: A full spline (`CatmullRomSpline`) can be any number of points,
/// and represents the users **full stroke**, from beginning to end.
///
/// A segment (`CatmullRomSegment`) is  sequence of (in my case) 4 points,
/// where `p1` and `p2` are interpolated, using the data of `p0` and `p3`
public struct CatmullRomSegment {
  public let p0: CGPoint
  public let p1: CGPoint
  public let p2: CGPoint
  public let p3: CGPoint

  // MARK: - Standard init
  public init(p0: CGPoint, p1: CGPoint, p2: CGPoint, p3: CGPoint) {
    self.p0 = p0
    self.p1 = p1
    self.p2 = p2
    self.p3 = p3
  }

  // MARK: - Initialise from an array of points
  public init?(points: [CGPoint]) {
    
    guard points.hasFourPoints else {
      print("Error: CatmullRomSpline requires at least 4 control points")
      return nil
    }
    self.init(
      p0: points[0],
      p1: points[1],
      p2: points[2],
      p3: points[3]
    )
  }
  
  public func interpolate(
    at t: CGFloat,
    type: CatmullRomType = .centripetal,
    tension: CGFloat = 0.5
  ) -> CGPoint {
    switch type {
      case .uniform:
        return CatmullRomSpline.catmullRomUniform(p0, p1, p2, p3, t, tension: tension)
      case .chordal, .centripetal:
        return CatmullRomSpline.catmullRomParameterized(p0, p1, p2, p3, t, type: type)
    }
  }

  public func interpolateScalar(
    values: [CGFloat],
    at t: CGFloat
  ) -> CGFloat? {
    guard values.count == 4 else {
      print("Error: recevived \(values.count) values, expected 4, as we are working with 4-point Catmull-Rom splines only.")
      return nil
    }
    
    let v0 = values[0]
    let v1 = values[1]
    let v2 = values[2]
    let v3 = values[3]
    
    return CatmullRomSegment.catmullRomScalarUniform(v0, v1, v2, v3, t)
  }
  
  public static func catmullRomScalarUniform(
    _ v0: CGFloat,
    _ v1: CGFloat,
    _ v2: CGFloat,
    _ v3: CGFloat,
    _ t: CGFloat
  ) -> CGFloat {
    let t2 = t * t
    let t3 = t2 * t
    
    return 0.5 * (
      2 * v1 +
      (v2 - v0) * t +
      (2 * v0 - 5 * v1 + 4 * v2 - v3) * t2 +
      (3 * v1 - v0 - 3 * v2 + v3) * t3
    )
  }

}

extension Array where Element == CGPoint {
  public var hasFourPoints: Bool {
    return count == 4
  }
}
