//
//  CatmullRom.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/5/2025.
//

import Foundation

/// A representation of a Catmull-Rom spline with various construction options
public struct CatmullRomSpline {
  /// The control points that define the spline
  private let points: [CGPoint]
  
  /// The tension parameter for uniform splines (default is 0.5)
  private let tension: CGFloat
  
  /// The parameterization type to use
  private let type: CatmullRomType
  
  /// Creates a Catmull-Rom spline from an array of points
  /// - Parameters:
  ///   - points: An array of at least 4 points
  ///   - type: The parameterization type (default is centripetal for drawing apps)
  ///   - tension: Controls curve tightness for uniform type only (between 0 and 1, default 0.5)
  /// - Returns: A new CatmullRomSpline instance or nil if fewer than 4 points provided
  public init?(points: [CGPoint], type: CatmullRomType = .centripetal, tension: CGFloat = 0.5) {
    guard points.count >= 4 else { return nil }
    self.points = points
    self.type = type
    self.tension = max(0, min(1, tension))
  }
  
  /// Evaluates the spline at the given parameter value
  /// - Parameters:
  ///   - t: The parameter value (normalized between 0 and 1)
  ///   - segmentIndex: The index of the segment to evaluate (default is 0)
  /// - Returns: The interpolated point on the spline
  public func evaluate(at t: CGFloat, segmentIndex: Int = 0) -> CGPoint? {
    // Ensure the segment index is valid
    guard segmentIndex >= 0 && segmentIndex + 3 < points.count else {
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
  
  // MARK: - Public Properties
  
  /// The number of control points in this spline
  public var count: Int {
    return points.count
  }
  
  /// The number of segments in this spline
  public var segmentCount: Int {
    return max(0, points.count - 3)
  }
  
  /// The parameterization type being used
  public var parameterizationType: CatmullRomType {
    return type
  }
  
  /// Access to the underlying control points
  public subscript(index: Int) -> CGPoint? {
    guard index >= 0 && index < points.count else { return nil }
    return points[index]
  }
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
}
