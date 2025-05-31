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
  
//  public func point(at t: CGFloat, type: CatmullRomType, tension: CGFloat = 0.5) -> CGPoint {
    // Evaluate curve at t ∈ [0, 1]
//  }
  
  
  public func interpolateScalar(values: [CGFloat], at t: CGFloat) -> CGFloat? {
    guard values.count == 4 else { return nil }
    
    let v0 = values[0]
    let v1 = values[1]
    let v2 = values[2]
    let v3 = values[3]
    
    // Use uniform Catmull-Rom for scalar values — that's perfectly valid
    return CatmullRomSegment.catmullRomScalarUniform(v0, v1, v2, v3, t)
  }
  
  public static func catmullRomScalarUniform(
    _ v0: CGFloat, _ v1: CGFloat, _ v2: CGFloat, _ v3: CGFloat, _ t: CGFloat
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

///// Represents a specific segment within a Catmull-Rom spline
//public struct CatmullRomSegment {
//  /// The spline this segment belongs to
//  private let spline: CatmullRomSpline
//
//  /// The index of this segment (0-based)
//  public let index: Int
//
//  /// The four control points that define this segment
//  public let controlPoints: (p0: CGPoint, p1: CGPoint, p2: CGPoint, p3: CGPoint)
//
//  internal init(spline: CatmullRomSpline, index: Int) {
//    self.spline = spline
//    self.index = index
//
//    // Extract the four control points for this segment
//    self.controlPoints = (
//      p0: spline[index: index]!,
//      p1: spline[index: index + 1]!,
//      p2: spline[index: index + 2]!,
//      p3: spline[index: index + 3]!
//    )
//  }
//
//  /// Evaluate this segment at parameter t (0-1)
//  /// - Parameter t: Parameter value between 0 and 1
//  /// - Returns: The interpolated point on this segment
//  public func evaluate(at t: CGFloat) -> CGPoint {
//    return spline.evaluateSegment(controlPoints, at: t)
//  }
//
//  /// Interpolate scalar values along this segment
//  /// - Parameters:
//  ///   - values: Array of scalar values (must match spline point count)
//  ///   - t: Parameter value between 0 and 1
//  /// - Returns: Interpolated scalar value
//  public func interpolateScalar(values: [CGFloat], at t: CGFloat) -> CGFloat? {
//    guard values.count == spline.count else { return nil }
//
//    let segmentValues = (
//      v0: values[index],
//      v1: values[index + 1],
//      v2: values[index + 2],
//      v3: values[index + 3]
//    )
//
//    return spline.interpolateScalarSegment(segmentValues, at: t)
//  }
//
//  /// The start point of this segment (p1)
//  public var startPoint: CGPoint { controlPoints.p1 }
//
//  /// The end point of this segment (p2)
//  public var endPoint: CGPoint { controlPoints.p2 }
//
//  /// A description of this segment for debugging
//  public var description: String {
//    "Segment \(index): \(startPoint) → \(endPoint)"
//  }
//}
