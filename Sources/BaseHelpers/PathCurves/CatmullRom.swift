//
//  CatmullRom.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/5/2025.
//

import SwiftUI

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

