//
//  CatmullRom.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/5/2025.
//

import Foundation

/// A representation of a Catmull-Rom spline with various construction options
/// A single user stroke, from beginning to end, can be represented by a single spline.
public struct CatmullRomSpline {
  /// The control points that define the spline
//  private let points: [CGPoint]
//  private let segment: CatmullRomSegment
  public let controlPoints: [CGPoint]
  
  /// The parameterization type to use
  private let type: CatmullRomType

  /// The tension parameter for uniform splines (default is 0.5)
  private let tension: CGFloat
  
  public var segments: [CatmullRomSegment] {
    guard controlPoints.hasFourPoints else { return [] }
//    return CatmullRomSegment(points: controlPoints)
    return (0..<controlPoints.count - 3).map {
      CatmullRomSegment(
        p0: controlPoints[$0],
        p1: controlPoints[$0 + 1],
        p2: controlPoints[$0 + 2],
        p3: controlPoints[$0 + 3]
      )
    }
  }
  
  public init?(
    points: [CGPoint],
    type: CatmullRomType = .centripetal,
    tension: CGFloat = 0.5
  ) {
    guard let segment = CatmullRomSegment(points: points) else {
      return nil
    }
    self.segment = segment
    self.type = type
    self.tension = max(0, min(1, tension))
  }
  
  public init?(
    segment: CatmullRomSegment,
    type: CatmullRomType = .centripetal,
    tension: CGFloat = 0.5
  ) {
    self.segment = segment
    self.type = type
    self.tension = max(0, min(1, tension))
  }
  
  /// Evaluates the spline at the given parameter value
  /// - Parameters:
  ///   - t: The parameter value (normalized between 0 and 1)
  ///   - segmentIndex: The index of the segment to evaluate (default is 0)
  /// - Returns: The interpolated point on the spline
  public func evaluate(
    at t: CGFloat,
    segmentIndex: Int = 0
  ) -> CGPoint? {
    /// Ensure the segment index is valid
    
    guard isValidSegmentIndex(segmentIndex, pointCount: points.count) else {
      print("Error evaluating, invalid segment index \(segmentIndex), with point count \(points.count).")
      return nil
    }
    
    // Get the four control points for the segment
    let p0 = points[segmentIndex]
    let p1 = points[segmentIndex + 1]
    let p2 = points[segmentIndex + 2]
    let p3 = points[segmentIndex + 3]
    
    // Use the appropriate interpolation method based on type
    switch type {
      case .uniform:
        return catmullRomUniform(p0, p1, p2, p3, t)
      case .centripetal, .chordal:
        return catmullRomParameterized(p0, p1, p2, p3, t, type: type)
    }
  }
  
  /// Generates points along the entire spline at the specified resolution
  /// - Parameter resolution: The number of points to generate per segment
  /// - Returns: An array of points along the spline
  public func generatePoints(resolution: Int = 20) -> [CGPoint] {
    var result: [CGPoint] = []
    
    // For each potential segment in the spline
    for segmentIndex in 0...(points.count - 4) {
      // Generate points along this segment
      for step in 0..<resolution {
        let t = CGFloat(step) / CGFloat(resolution - 1)
        if let point = evaluate(at: t, segmentIndex: segmentIndex) {
          result.append(point)
        }
      }
    }
    
    return result
  }
  
  // MARK: - Private Implementation Methods
  
  /// The original tensor-based Catmull-Rom interpolation (uniform parameterization)
  private func catmullRomUniform(
    _ p0: CGPoint,
    _ p1: CGPoint,
    _ p2: CGPoint,
    _ p3: CGPoint,
    _ t: CGFloat
  ) -> CGPoint {
    let t2 = t * t
    let t3 = t2 * t
    
    // Tension factor
    let a = 2 * t3 - 3 * t2 + 1
    let b = -2 * t3 + 3 * t2
    let c = t3 - 2 * t2 + t
    let d = t3 - t2
    
    // Adjust c and d with tension parameter
    let adjustedC = c * tension
    let adjustedD = d * tension
    
    // Calculate the x and y coordinates
    let x = a * p1.x + b * p2.x + adjustedC * (p2.x - p0.x) + adjustedD * (p3.x - p1.x)
    let y = a * p1.y + b * p2.y + adjustedC * (p2.y - p0.y) + adjustedD * (p3.y - p1.y)
    
    return CGPoint(x: x, y: y)
  }
  
  /// Parameterized Catmull-Rom using De Casteljau-style algorithm
  private func catmullRomParameterized(
    _ p0: CGPoint,
    _ p1: CGPoint,
    _ p2: CGPoint,
    _ p3: CGPoint,
    _ t: CGFloat,
    type: CatmullRomType
  ) -> CGPoint {
    let alpha: CGFloat
    switch type {
      case .uniform: alpha = 0.0      // Shouldn't reach here, but safe fallback
      case .chordal: alpha = 1.0
      case .centripetal: alpha = 0.5
    }
    
    func tj(_ ti: CGFloat, _ pi: CGPoint, _ pj: CGPoint) -> CGFloat {
      let dx = pj.x - pi.x
      let dy = pj.y - pi.y
      return pow(dx * dx + dy * dy, alpha * 0.5) + ti
    }
    
    let t0: CGFloat = 0
    let t1 = tj(t0, p0, p1)
    let t2 = tj(t1, p1, p2)
    let t3 = tj(t2, p2, p3)
    
    // Map t in [0, 1] to τ in [t1, t2]
    let tau = t1 + (t2 - t1) * t
    
    // Perform the recursive interpolation (De Casteljau-like)
    let A1 = interpolate(p0, p1, (tau - t0) / (t1 - t0))
    let A2 = interpolate(p1, p2, (tau - t1) / (t2 - t1))
    let A3 = interpolate(p2, p3, (tau - t2) / (t3 - t2))
    
    let B1 = interpolate(A1, A2, (tau - t1) / (t2 - t1))
    let B2 = interpolate(A2, A3, (tau - t2) / (t3 - t2))
    
    return interpolate(B1, B2, (tau - t2) / (t3 - t2))
  }
  
  /// Linear interpolation helper
  private func interpolate(_ p0: CGPoint, _ p1: CGPoint, _ t: CGFloat) -> CGPoint {
    CGPoint(
      x: p0.x + (p1.x - p0.x) * t,
      y: p0.y + (p1.y - p0.y) * t
    )
  }
  
  /// Interpolates scalar values using the same parameterization as the spline
  /// - Parameters:
  ///   - values: Array of scalar values corresponding to the control points
  ///   - t: Parameter value (0-1)
  ///   - segmentIndex: Which segment to interpolate within
  /// - Returns: Interpolated scalar value
  public func interpolateScalar(
    values: [CGFloat],
    at t: CGFloat,
    segmentIndex: Int = 0
  ) -> CGFloat? {
    guard values.count == points.count else {
      print("Error: Number of scalar values `\(values.count)` must match number of points `\(points.count)`.")
      return nil
    }
    
    guard isValidSegmentIndex(
      segmentIndex,
      pointCount: values.count
    ) else {
      print("Error: Invalid segment index `\(segmentIndex)` with point count `\(values.count)`.")
      return nil
    }
    
    let v0 = values[segmentIndex]
    let v1 = values[segmentIndex + 1]
    let v2 = values[segmentIndex + 2]
    let v3 = values[segmentIndex + 3]
    
    switch type {
      case .uniform:
        return catmullRomScalarUniform(v0, v1, v2, v3, t)
      case .centripetal, .chordal:
        /// For scalar interpolation with parameterized splines, we can use the uniform formula
        /// since we don't have spatial relationships between scalar values
        return catmullRomScalarUniform(v0, v1, v2, v3, t)
    }
  }
  
  private func isValidSegmentIndex(
    _ index: Int,
    pointCount: Int
  ) -> Bool {
    return index >= 0 && index + 3 < pointCount
//    precondition(, "Invalid segment index \(index)")
  }
  
  /// Uniform Catmull-Rom interpolation for scalar values
  private func catmullRomScalarUniform(_ v0: CGFloat, _ v1: CGFloat, _ v2: CGFloat, _ v3: CGFloat, _ t: CGFloat) -> CGFloat {
    let t2 = t * t
    let t3 = t2 * t
    
    return 0.5 * (
      2 * v1 +
      (v2 - v0) * t +
      (2 * v0 - 5 * v1 + 4 * v2 - v3) * t2 +
      (3 * v1 - v0 - 3 * v2 + v3) * t3
    )
  }
  
  // MARK: - Public Properties
  
  /// The number of control points in this spline
//  public var count: Int {
//    return points.count
//  }
  
  /// The number of segments in this spline
//  public var segmentCount: Int {
//    return max(0, points.count - 3)
//  }
  
  /// The parameterization type being used
//  public var parameterizationType: CatmullRomType {
//    return type
//  }
  
  /// Get a specific segment by index
  /// - Parameter index: The segment index (0-based)
  /// - Returns: A CatmullRomSegment or nil if index is invalid
//  public func segment(_ index: Int) -> CatmullRomSegment? {
//    guard index >= 0 && index < segmentCount else { return nil }
//    return CatmullRomSegment(spline: self, index: index)
//  }
  
  /// Get all segments in this spline
//  public var segments: [CatmullRomSegment] {
//    return (0..<segmentCount).compactMap { segment($0) }
//  }
  
  /// Find the segment that contains a specific control point
  /// - Parameter pointIndex: Index of the control point
  /// - Returns: Array of segments that use this control point (usually 1-4 segments)
//  public func segmentsContaining(pointIndex: Int) -> [CatmullRomSegment] {
//    guard pointIndex >= 0 && pointIndex < count else { return [] }
//    
//    var containingSegments: [CatmullRomSegment] = []
//    
//    // A control point can be part of up to 4 segments
//    for segmentIndex in max(0, pointIndex - 3)...min(segmentCount - 1, pointIndex) {
//      if let segment = segment(segmentIndex) {
//        containingSegments.append(segment)
//      }
//    }
//    
//    return containingSegments
//  }
  
  // MARK: - Internal methods for CatmullRomSegment
  
//  internal func evaluateSegment(_ controlPoints: (CGPoint, CGPoint, CGPoint, CGPoint), at t: CGFloat) -> CGPoint {
//    switch type {
//      case .uniform:
//        return catmullRomUniform(controlPoints.0, controlPoints.1, controlPoints.2, controlPoints.3, t)
//      case .centripetal, .chordal:
//        return catmullRomParameterized(controlPoints.0, controlPoints.1, controlPoints.2, controlPoints.3, t, type: type)
//    }
//  }
//  
//  internal func interpolateScalarSegment(_ values: (CGFloat, CGFloat, CGFloat, CGFloat), at t: CGFloat) -> CGFloat {
//    return catmullRomScalarUniform(values.0, values.1, values.2, values.3, t)
//  }
//  
//  /// Access to the underlying control points
//  public subscript(index index: Int) -> CGPoint? {
//    guard index >= 0 && index < points.count else {
//      print("Couldn't get valid point")
//      return nil
//    }
//    return points[index]
//  }
}

// MARK: - Convenience Extensions

extension CatmullRomSpline {
  /// Create a spline optimized for drawing applications (uses centripetal parameterization)
  public static func forDrawing(points: [CGPoint]) -> CatmullRomSpline? {
    return CatmullRomSpline(
      points: points,
      type: .centripetal
    )
  }
  
  /// Create a fast spline for when performance is critical (uses uniform parameterization)
  public static func forPerformance(points: [CGPoint], tension: CGFloat = 0.5) -> CatmullRomSpline? {
    return CatmullRomSpline(
      points: points,
      type: .uniform,
      tension: tension
    )
  }
  
  /// Generate points along the entire spline using the segment-based API
  /// - Parameter pointsPerSegment: Number of points to generate per segment
  /// - Returns: Array of points along the spline
//  public func generatePointsUsingSegments(pointsPerSegment: Int = 20) -> [CGPoint] {
//    var result: [CGPoint] = []
//    
//    for segment in segments {
//      for step in 0..<pointsPerSegment {
//        let t = CGFloat(step) / CGFloat(pointsPerSegment - 1)
//        result.append(segment.evaluate(at: t))
//      }
//    }
//    
//    return result
//  }
//  
//  /// Create a spline and immediately access its first segment (common pattern)
//  public static func firstSegment(of points: [CGPoint], type: CatmullRomType = .centripetal) -> CatmullRomSegment? {
//    guard let spline = CatmullRomSpline(points: points, type: type) else { return nil }
//    return spline.segment(0)
//  }
}
