//
//  ShiftPoints.swift
//  Collection
//
//  Created by Dave Coleman on 4/10/2024.
//

import SwiftUI

public extension CGPoint {
  // Shift right (increases x)
  func shiftRight(_ distance: CGFloat) -> CGPoint {
    return CGPoint(x: self.x + distance, y: self.y)
  }
  
  // Shift left (decreases x)
  func shiftLeft(_ distance: CGFloat) -> CGPoint {
    return CGPoint(x: self.x - distance, y: self.y)
  }
  
  // Shift down (increases y)
  func shiftDown(_ distance: CGFloat) -> CGPoint {
    return CGPoint(x: self.x, y: self.y + distance)
  }
  
  // Shift up (decreases y)
  func shiftUp(_ distance: CGFloat) -> CGPoint {
    return CGPoint(x: self.x, y: self.y - distance)
  }
  
  // Shift diagonally
  func shift(dx: CGFloat, dy: CGFloat) -> CGPoint {
    return CGPoint(x: self.x + dx, y: self.y + dy)
  }
  
  // Shift by another point
  func shift(by point: CGPoint) -> CGPoint {
    return CGPoint(x: self.x + point.x, y: self.y + point.y)
  }
  
  /// Find a point along the line between two points
  /// Example usage
  ///
  /// ```
  /// let point1 = CGPoint(x: 0, y: 0)
  /// let point2 = CGPoint(x: 100, y: 100)
  ///
  /// let midpoint = CGPoint.pointAlong(from: point1, to: point2, t: 0.5)
  /// print("Midpoint: \(midpoint)") // Should print (50, 50)
  ///
  /// let quarterPoint = point1.pointAlong(to: point2, t: 0.25)
  /// print("Quarter point: \(quarterPoint)") // Should print (25, 25)
  ///
  /// ```
  
  static func pointAlong(from start: CGPoint, to end: CGPoint, t: CGFloat) -> CGPoint {
    let clampedT = max(0, min(1, t)) // Ensure t is between 0 and 1
    return CGPoint(
      x: start.x + (end.x - start.x) * clampedT,
      y: start.y + (end.y - start.y) * clampedT
    )
  }
  
  // Convenience method to find a point along a line starting from self
  func pointAlong(to end: CGPoint, t: CGFloat) -> CGPoint {
    return CGPoint.pointAlong(from: self, to: end, t: t)
  }
}

// Example usage
//struct ContentView: View {
//  var body: some View {
//    let basePoint = CGPoint(x: 100, y: 100)
//    
//    Path { path in
//      path.move(to: basePoint)
//      path.addLine(to: basePoint.shiftRight(50))
//      path.addLine(to: basePoint.shiftRight(50).shiftDown(50))
//      path.addLine(to: basePoint.shiftDown(50))
//      path.closeSubpath()
//    }
//    .stroke(Color.blue, lineWidth: 2)
//    .frame(width: 200, height: 200)
//  }
//}
