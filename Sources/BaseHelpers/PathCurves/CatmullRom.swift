//
//  CatmullRom.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/5/2025.
//

import SwiftUI

public struct CatmullRom {

  static func catmullRomPath(for points: [CGPoint]) -> Path {
    var path = Path()

    /// Start at first point
    path.move(to: points[0])

    /// Need at least 4 points for Catmull-Rom
    if points.count >= 4 {
      for i in 1..<points.count - 2 {
        let p0 = i > 0 ? points[i - 1] : points[i]
        let p1 = points[i]
        let p2 = points[i + 1]
        let p3 = i < points.count - 2 ? points[i + 2] : points[i + 1]

        /// Add cubic curve using Catmull-Rom control points
        let controlPoint1 = CGPoint(
          x: p1.x + (p2.x - p0.x) / 6,
          y: p1.y + (p2.y - p0.y) / 6
        )

        let controlPoint2 = CGPoint(
          x: p2.x - (p3.x - p1.x) / 6,
          y: p2.y - (p3.y - p1.y) / 6
        )

        path.addCurve(to: p2, control1: controlPoint1, control2: controlPoint2)
      }
    } else {
      /// Fallback for fewer points
      for i in 1..<points.count {
        path.addLine(to: points[i])
      }
    }
    return path
  }
}
