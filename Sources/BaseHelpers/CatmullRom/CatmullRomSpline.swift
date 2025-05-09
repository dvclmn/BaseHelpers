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
  
  /// The tension parameter that controls the curvature (default is 0.5)
  private let tension: CGFloat
  
  /// Creates a Catmull-Rom spline from an array of points
  /// - Parameters:
  ///   - points: An array of at least 4 points
  ///   - tension: Controls how tight the curve is (between 0 and 1, default 0.5)
  /// - Returns: A new CatmullRomSpline instance or nil if fewer than 4 points provided
  public init?(points: [CGPoint], tension: CGFloat = 0.5) {
    guard points.count >= 4 else { return nil }
    self.points = points
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
    
    // Calculate the interpolated point
    return catmullRom(p0, p1, p2, p3, t)
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
  
  /// The core Catmull-Rom interpolation function
  private func catmullRom(
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
  
  /// The number of control points in this spline
  public var count: Int {
    return points.count
  }
  
  /// The number of segments in this spline
  public var segmentCount: Int {
    return max(0, points.count - 3)
  }
  
  /// Access to the underlying control points
  public subscript(index: Int) -> CGPoint? {
    guard index >= 0 && index < points.count else { return nil }
    return points[index]
  }
}

// MARK: - Builder Pattern

/// Builder for creating Catmull-Rom splines
public class CatmullRomSplineBuilder {
  private var points: [CGPoint] = []
  private var tension: CGFloat = 0.5
  
  /// Adds a point to the spline
  @discardableResult
  public func addPoint(_ point: CGPoint) -> CatmullRomSplineBuilder {
    points.append(point)
    return self
  }
  
  /// Adds multiple points to the spline
  @discardableResult
  public func addPoints(_ newPoints: [CGPoint]) -> CatmullRomSplineBuilder {
    points.append(contentsOf: newPoints)
    return self
  }
  
  /// Sets the tension parameter of the spline
  @discardableResult
  public func withTension(_ tension: CGFloat) -> CatmullRomSplineBuilder {
    self.tension = max(0, min(1, tension))
    return self
  }
  
  /// Builds the spline if enough points are available
  public func build() -> CatmullRomSpline? {
    return CatmullRomSpline(points: points, tension: tension)
  }
  
  /// Creates a closed loop by duplicating the first few points at the end
  @discardableResult
  public func closeLoop() -> CatmullRomSplineBuilder {
    // Need at least 3 points to create a meaningful loop
    guard points.count >= 3 else { return self }
    
    // Add the first three points again to close the loop
    // This ensures the spline connects smoothly
    let pointsToAdd = min(3, points.count)
    for i in 0..<pointsToAdd {
      points.append(points[i])
    }
    
    return self
  }
}

// MARK: - Factory Methods

extension CatmullRomSpline {
  /// Creates a builder for fluent construction of a spline
  public static func builder() -> CatmullRomSplineBuilder {
    return CatmullRomSplineBuilder()
  }
  
  /// Creates a closed loop spline from the given points
  public static func closedLoop(points: [CGPoint], tension: CGFloat = 0.5) -> CatmullRomSpline? {
    guard points.count >= 3 else { return nil }
    
    var loopPoints = points
    // Add the first three points again (or fewer if we don't have enough)
    let pointsToAdd = min(3, points.count)
    for i in 0..<pointsToAdd {
      loopPoints.append(points[i])
    }
    
    return CatmullRomSpline(points: loopPoints, tension: tension)
  }
  
  /// Creates a spline from a line with the specified number of points
  public static func fromLine(start: CGPoint, end: CGPoint, pointCount: Int = 4) -> CatmullRomSpline? {
    guard pointCount >= 4 else { return nil }
    
    var points: [CGPoint] = []
    for i in 0..<pointCount {
      let t = CGFloat(i) / CGFloat(pointCount - 1)
      let x = start.x + (end.x - start.x) * t
      let y = start.y + (end.y - start.y) * t
      points.append(CGPoint(x: x, y: y))
    }
    
    return CatmullRomSpline(points: points)
  }
}

// MARK: - Usage Examples

/// ```
/// // Example 1: Basic initialization
/// let points = [
///   CGPoint(x: 0, y: 0),
///   CGPoint(x: 100, y: 0),
///   CGPoint(x: 100, y: 100),
///   CGPoint(x: 0, y: 100)
/// ]
/// let spline = CatmullRomSpline(points: points)
///
/// // Example 2: Using the builder pattern
/// let builderSpline = CatmullRomSpline.builder()
///   .addPoint(CGPoint(x: 0, y: 0))
///   .addPoint(CGPoint(x: 100, y: 0))
///   .addPoint(CGPoint(x: 100, y: 100))
///   .addPoint(CGPoint(x: 0, y: 100))
///   .withTension(0.7)
///   .build()
///
/// // Example 3: Creating a closed loop
/// let loopSpline = CatmullRomSpline.closedLoop(points: points)
///
/// // Example 4: Generating points along the spline
/// if let generatedSpline = builderSpline {
///   let pathPoints = generatedSpline.generatePoints(resolution: 30)
///   // Use pathPoints to draw the spline
/// }
///
/// // Example 5: Creating a path from the spline
/// func createPath(from spline: CatmullRomSpline, closed: Bool = false) -> CGPath {
///   let path = CGMutablePath()
///   let points = spline.generatePoints(resolution: 30)
///
///   if let firstPoint = points.first {
///     path.move(to: firstPoint)
///
///     for i in 1..<points.count {
///       path.addLine(to: points[i])
///     }
///
///     if closed {
///       path.closeSubpath()
///     }
///   }
///
///   return path
/// }
/// ```

//public struct CatmullRom {
//  
//  public static func catmullRomPoints(
//    for points: [CGPoint],
//    tension: CGFloat = 0.0,
//    closed: Bool = false
//  ) -> [CGPoint] {
//    guard !points.isEmpty else { return [] }
//    
//    /// Handle special cases with insufficient points
//    if points.count == 1 {
//      return [points[0]]
//    } else if points.count < 4 && !closed {
//      return points
//    }
//    
//    // Default resolution of 10 points per segment
//    let resolution = 10
//    let segmentCount = closed ? points.count : points.count - 1
//    let totalPoints = segmentCount * resolution
//    
//    return generatePointsAlongPath(
//      for: points,
//      count: totalPoints,
//      tension: tension,
//      closed: closed
//    )
//  }
//  
//  
//  /// Tension parameter - controls how "tight" the curve is
//  /// - 0.0: Creates Catmull-Rom splines (curves pass through points)
//  /// - 1.0: Creates a cardinal spline
//  /// - Default: 0.0 for standard Catmull-Rom behavior
//  public static func catmullRomPath(
//    for points: [CGPoint],
//    tension: CGFloat = 0.0,
//    closed: Bool = false
//  ) -> Path {
//    guard !points.isEmpty else { return Path() }
//    
//    var path = Path()
//    
//    /// Handle special cases with insufficient points
//    if points.count == 1 {
//      /// For a single point, just move to it
//      path.move(to: points[0])
//      return path
//    } else if points.count < 4 && !closed {
//      /// For 2-3 points without closing, use simple lines
//      path.move(to: points[0])
//      for i in 1..<points.count {
//        path.addLine(to: points[i])
//      }
//      return path
//    }
//    
//    /// Create a working array that might include wrapped points for closed paths
//    var workingPoints = points
//    if closed && points.count >= 3 {
//      /// For closed paths, wrap around points to ensure smooth closure
//      workingPoints.append(points[0])
//      workingPoints.insert(points[points.count - 1], at: 0)
//    }
//    
//    path.move(to: workingPoints[closed ? 1 : 0])
//    
//    /// Calculate the actual tension factor
//    #warning("Tension: Your alpha = (1 - tension) / 6.0 formula is consistent with standard centripetal Catmull-Rom approaches. You might want to expose preset types (uniform, centripetal, chordal) if you plan on tweaking the feel.")
//    let alpha = (1.0 - tension) / 6.0
//    
//    /// Calculate spline for each segment
//    let endIndex = closed ? workingPoints.count - 2 : workingPoints.count - 1
//    for i in (closed ? 1 : 0)..<endIndex {
//      let p0 = workingPoints[max(0, i - 1)]
//      let p1 = workingPoints[i]
//      let p2 = workingPoints[min(workingPoints.count - 1, i + 1)]
//      let p3 = workingPoints[min(workingPoints.count - 1, i + 2)]
//      
//      /// Calculate control points based on Catmull-Rom formula with tension
//      let controlPoint1 = CGPoint(
//        x: p1.x + alpha * (p2.x - p0.x),
//        y: p1.y + alpha * (p2.y - p0.y)
//      )
//      
//      let controlPoint2 = CGPoint(
//        x: p2.x - alpha * (p3.x - p1.x),
//        y: p2.y - alpha * (p3.y - p1.y)
//      )
//      
//      path.addCurve(to: p2, control1: controlPoint1, control2: controlPoint2)
//    }
//    
//    /// Close the path if needed
//    if closed {
//      path.closeSubpath()
//    }
//    
//    return path
//  }
//  
//  /// Generates points along a Catmull-Rom spline at specified resolution
//  /// Useful for collision detection or other precise calculations
//  public static func interpolatedPoints(
//    for points: [CGPoint],
//    resolution: Int = 10,
//    tension: CGFloat = 0.0,
//    closed: Bool = false
//  ) -> [CGPoint] {
//    /// Just use the direct point generation method
//    return generatePointsAlongPath(
//      for: points,
//      count: (points.count - 1) * resolution,
//      tension: tension,
//      closed: closed
//    )
//  }
//  /// Generate points along a spline
//  public static func generatePointsAlongPath(
//    for points: [CGPoint],
//    count: Int,
//    tension: CGFloat = 0.0,
//    closed: Bool = false
//  ) -> [CGPoint] {
//    guard points.count >= 2 else { return points }
//    guard count > 0 else { return [] }
//    
//    var result = [CGPoint]()
//    
//    /// Create a working array that might include wrapped points for closed paths
//    var workingPoints = points
//    if closed && points.count >= 3 {
//      workingPoints.append(points[0])
//      workingPoints.insert(points[points.count - 1], at: 0)
//    }
//    
//    /// Calculate the actual tension factor
//    let alpha = (1.0 - tension) / 6.0
//    
//    /// For each segment between points, generate interpolated points
//    let startIndex = closed ? 1 : 0
//    let endIndex = closed ? workingPoints.count - 2 : workingPoints.count - 1
//    
//    /// How many points to generate per segment
//    let pointsPerSegment = max(2, count / max(1, endIndex - startIndex))
//    
//    /// Add the first point
//    if !closed {
//      result.append(workingPoints[0])
//    }
//    
//    for i in startIndex..<endIndex - 1 {
//      let p0 = workingPoints[max(0, i - 1)]
//      let p1 = workingPoints[i]
//      let p2 = workingPoints[i + 1]
//      let p3 = workingPoints[min(workingPoints.count - 1, i + 2)]
//      
//      /// Control points for this segment
//      let cp1 = CGPoint(
//        x: p1.x + alpha * (p2.x - p0.x),
//        y: p1.y + alpha * (p2.y - p0.y)
//      )
//      
//      let cp2 = CGPoint(
//        x: p2.x - alpha * (p3.x - p1.x),
//        y: p2.y - alpha * (p3.y - p1.y)
//      )
//      
//      /// Generate points along this cubic Bézier segment
//      if i > startIndex || closed {  // Skip first point after the first iteration
//                                     // Don't add p1 again if it's not the first segment
//        for j in 0..<pointsPerSegment {
//          let t = CGFloat(j) / CGFloat(pointsPerSegment)
//          
//          // Cubic Bézier formula
//          let mt = 1 - t
//          let mt2 = mt * mt
//          let mt3 = mt2 * mt
//          let t2 = t * t
//          let t3 = t2 * t
//          
//          let x = mt3 * p1.x + 3 * mt2 * t * cp1.x + 3 * mt * t2 * cp2.x + t3 * p2.x
//          let y = mt3 * p1.y + 3 * mt2 * t * cp1.y + 3 * mt * t2 * cp2.y + t3 * p2.y
//          
//          result.append(CGPoint(x: x, y: y))
//        }
//      } else {
//        /// For the first segment, include the starting point
//        for j in 0..<pointsPerSegment {
//          let t = CGFloat(j) / CGFloat(pointsPerSegment)
//          
//          /// Cubic Bézier formula
//          let mt = 1 - t
//          let mt2 = mt * mt
//          let mt3 = mt2 * mt
//          let t2 = t * t
//          let t3 = t2 * t
//          
//          let x = mt3 * p1.x + 3 * mt2 * t * cp1.x + 3 * mt * t2 * cp2.x + t3 * p2.x
//          let y = mt3 * p1.y + 3 * mt2 * t * cp1.y + 3 * mt * t2 * cp2.y + t3 * p2.y
//          
//          result.append(CGPoint(x: x, y: y))
//        }
//      }
//    }
//    
//    /// Add the last point if not closed
//    if !closed {
//      result.append(workingPoints[workingPoints.count - 1])
//    }
//    
//    return result
//  }
//} // END Catmull rom struct

