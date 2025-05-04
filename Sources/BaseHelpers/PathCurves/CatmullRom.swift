//
//  CatmullRom.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/5/2025.
//

import SwiftUI

import SwiftUI

public struct CatmullRom {
  /// Tension parameter - controls how "tight" the curve is
  /// - 0.0: Creates Catmull-Rom splines (curves pass through points)
  /// - 1.0: Creates a cardinal spline
  /// - Default: 0.0 for standard Catmull-Rom behavior
  public static func catmullRomPath(
    for points: [CGPoint],
    tension: CGFloat = 0.0,
    closed: Bool = false
  ) -> Path {
    guard !points.isEmpty else { return Path() }
    
    var path = Path()
    
    // Handle special cases with insufficient points
    if points.count == 1 {
      // For a single point, just move to it
      path.move(to: points[0])
      return path
    } else if points.count < 4 && !closed {
      // For 2-3 points without closing, use simple lines
      path.move(to: points[0])
      for i in 1..<points.count {
        path.addLine(to: points[i])
      }
      return path
    }
    
    /// Create a working array that might include wrapped points for closed paths
    var workingPoints = points
    if closed && points.count >= 3 {
      /// For closed paths, wrap around points to ensure smooth closure
      workingPoints.append(points[0])
      workingPoints.insert(points[points.count - 1], at: 0)
    }
    
    path.move(to: workingPoints[closed ? 1 : 0])
    
    // Calculate the actual tension factor
    let alpha = (1.0 - tension) / 6.0
    
    // Calculate spline for each segment
    let endIndex = closed ? workingPoints.count - 2 : workingPoints.count - 1
    for i in (closed ? 1 : 0)..<endIndex {
      let p0 = workingPoints[max(0, i - 1)]
      let p1 = workingPoints[i]
      let p2 = workingPoints[min(workingPoints.count - 1, i + 1)]
      let p3 = workingPoints[min(workingPoints.count - 1, i + 2)]
      
      // Calculate control points based on Catmull-Rom formula with tension
      let controlPoint1 = CGPoint(
        x: p1.x + alpha * (p2.x - p0.x),
        y: p1.y + alpha * (p2.y - p0.y)
      )
      
      let controlPoint2 = CGPoint(
        x: p2.x - alpha * (p3.x - p1.x),
        y: p2.y - alpha * (p3.y - p1.y)
      )
      
      path.addCurve(to: p2, control1: controlPoint1, control2: controlPoint2)
    }
    
    // Close the path if needed
    if closed {
      path.closeSubpath()
    }
    
    return path
  }
  
  /// Generates points along a Catmull-Rom spline at specified resolution
  /// Useful for collision detection or other precise calculations
  public static func interpolatedPoints(
    for points: [CGPoint],
    resolution: Int = 10,
    tension: CGFloat = 0.0,
    closed: Bool = false
  ) -> [CGPoint] {
    guard points.count >= 2 else { return points }
    
    let path = catmullRomPath(for: points, tension: tension, closed: closed)
    
    // Use SwiftUI's built-in path interpolation to get points along the path
    var result = [CGPoint]()
    let totalSegments = (points.count - 1) * resolution
    
    for i in 0...totalSegments {
      let t = CGFloat(i) / CGFloat(totalSegments)
      if let point = path.point(at: t) {
        result.append(point)
      }
    }
    
    return result
  }
}

// Extension to get points along a path
extension Path {
  func point(at offset: CGFloat) -> CGPoint? {
    guard offset >= 0, offset <= 1 else { return nil }
    
    var result: CGPoint?
    var pathOffset: CGFloat = 0
    
    self.forEach { element in
      switch element {
        case .move(let to):
          result = to
          
        case .line(let to):
          if let from = result {
            let t = min(max(0, (offset - pathOffset) / 0.01), 1)
            result = CGPoint(
              x: from.x + (to.x - from.x) * t,
              y: from.y + (to.y - from.y) * t
            )
            pathOffset += 0.01
          } else {
            result = to
          }
          
          
        case .curve(let to, let control1, let control2):
          if let from = result {
            let t = min(max(0, (offset - pathOffset) / 0.01), 1)
            // Cubic Bézier calculation
            let mt = 1 - t
            let mt2 = mt * mt
            let mt3 = mt2 * mt
            let t2 = t * t
            let t3 = t2 * t
            
            result = CGPoint(
              x: mt3 * from.x + 3 * mt2 * t * control1.x + 3 * mt * t2 * control2.x + t3 * to.x,
              y: mt3 * from.y + 3 * mt2 * t * control1.y + 3 * mt * t2 * control2.y + t3 * to.y
            )
            pathOffset += 0.01
          } else {
            result = to
          }

          case .quadCurve(let to, let control):
          if let from = result {
            let t = min(max(0, (offset - pathOffset) / 0.01), 1)
            // Quadratic Bézier calculation
            let mt = 1 - t
            let mt2 = mt * mt
            let t2 = t * t
          
            result = CGPoint(
              x: mt2 * from.x + 2 * mt * t * control.x + t2 * to.x,
              y: mt2 * from.y + 2 * mt * t * control.y + t2 * to.y
            )
            pathOffset += 0.01
          } else {
            result = to
            }

          
        case .closeSubpath:
          break
          
        default:
          break
      }
    }
    
    return result
  }
}

//extension CatmullRom {
//  func handleCurvePath(
//    point: CGPoint?,
//    offset: CGFloat,
//    pathOffset: CGFloat,
//    to: CGPoint,
//    control1: CGPoint,
//    control2: CGPoint
//  ) -> CGPoint {
//    if let from = point {
//      let t = min(max(0, (offset - pathOffset) / 0.01), 1)
//      // Cubic Bézier calculation
//      let mt = 1 - t
//      let mt2 = mt * mt
//      let mt3 = mt2 * mt
//      let t2 = t * t
//      let t3 = t2 * t
//      
//      return CGPoint(
//        x: mt3 * from.x + 3 * mt2 * t * control1.x + 3 * mt * t2 * control2.x + t3 * to.x,
//        y: mt3 * from.y + 3 * mt2 * t * control1.y + 3 * mt * t2 * control2.y + t3 * to.y
//      )
//      pathOffset += 0.01
//    } else {
//      return to
//    }
//  }
//}
//
//
