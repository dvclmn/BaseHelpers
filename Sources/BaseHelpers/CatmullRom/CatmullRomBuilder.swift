//
//  CatmullRomBuilder.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/5/2025.
//

import Foundation

//// MARK: - Builder Pattern
//
///// Builder for creating Catmull-Rom splines
//public class CatmullRomSplineBuilder {
//  private var points: [CGPoint] = []
//  private var tension: CGFloat = 0.5
//  
//  /// Adds a point to the spline
//  @discardableResult
//  public func addPoint(_ point: CGPoint) -> CatmullRomSplineBuilder {
//    points.append(point)
//    return self
//  }
//  
//  /// Adds multiple points to the spline
//  @discardableResult
//  public func addPoints(_ newPoints: [CGPoint]) -> CatmullRomSplineBuilder {
//    points.append(contentsOf: newPoints)
//    return self
//  }
//  
//  /// Sets the tension parameter of the spline
//  @discardableResult
//  public func withTension(_ tension: CGFloat) -> CatmullRomSplineBuilder {
//    self.tension = max(0, min(1, tension))
//    return self
//  }
//  
//  /// Builds the spline if enough points are available
//  public func build() -> CatmullRomSpline? {
//    return CatmullRomSpline(points: points, tension: tension)
//  }
//  
//  /// Creates a closed loop by duplicating the first few points at the end
//  @discardableResult
//  public func closeLoop() -> CatmullRomSplineBuilder {
//    // Need at least 3 points to create a meaningful loop
//    guard points.count >= 3 else { return self }
//    
//    // Add the first three points again to close the loop
//    // This ensures the spline connects smoothly
//    let pointsToAdd = min(3, points.count)
//    for i in 0..<pointsToAdd {
//      points.append(points[i])
//    }
//    
//    return self
//  }
//}
//
//// MARK: - Factory Methods
//
//extension CatmullRomSpline {
//  /// Creates a builder for fluent construction of a spline
//  public static func builder() -> CatmullRomSplineBuilder {
//    return CatmullRomSplineBuilder()
//  }
//  
//  /// Creates a closed loop spline from the given points
//  public static func closedLoop(points: [CGPoint], tension: CGFloat = 0.5) -> CatmullRomSpline? {
//    guard points.count >= 3 else { return nil }
//    
//    var loopPoints = points
//    // Add the first three points again (or fewer if we don't have enough)
//    let pointsToAdd = min(3, points.count)
//    for i in 0..<pointsToAdd {
//      loopPoints.append(points[i])
//    }
//    
//    return CatmullRomSpline(points: loopPoints, tension: tension)
//  }
//  
//  /// Creates a spline from a line with the specified number of points
//  public static func fromLine(start: CGPoint, end: CGPoint, pointCount: Int = 4) -> CatmullRomSpline? {
//    guard pointCount >= 4 else { return nil }
//    
//    var points: [CGPoint] = []
//    for i in 0..<pointCount {
//      let t = CGFloat(i) / CGFloat(pointCount - 1)
//      let x = start.x + (end.x - start.x) * t
//      let y = start.y + (end.y - start.y) * t
//      points.append(CGPoint(x: x, y: y))
//    }
//    
//    return CatmullRomSpline(points: points)
//  }
//}
