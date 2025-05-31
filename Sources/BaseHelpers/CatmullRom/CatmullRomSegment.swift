//
//  CRomSegment.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/5/2025.
//

import Foundation

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

  // MARK: - Initialise from an array
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
