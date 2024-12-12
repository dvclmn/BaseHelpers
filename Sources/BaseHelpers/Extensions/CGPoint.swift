//
//  CGPoint.swift
//  Collection
//
//  Created by Dave Coleman on 16/11/2024.
//

import SwiftUI

public extension CGPoint {
  
  func addingDelta(_ delta: CGPoint) -> CGPoint {
    let result = CGPoint(
      x: self.x + (delta.x),
      y: self.y + (delta.y)
    )
    return result
  }
  
  func calculateDelta(
    from lastPosition: CGPoint,
    with sensitivity: CGFloat
  ) -> CGPoint {
    let result = CGPoint(
      x: (self.x - lastPosition.x) * sensitivity,
      y: (self.y - lastPosition.y) * sensitivity
    )
    
    return result
  }
  
  func unitPoint(in size: CGSize) -> UnitPoint {
    guard size.width > 0 && size.height > 0 else {
      return .center // or another reasonable default
    }
    
    return UnitPoint(x: x / size.width, y: y / size.height)
  }
  
  func displayString(decimalPlaces: Int = 2) -> String {
    return "\(self.x.toDecimal(decimalPlaces)) x \(self.y.toDecimal(decimalPlaces))"
  }
  
  func displayString(decimalPlaces: Int = 2, style: StringStyle = .short) -> String {
    
    let width: String = "\(self.x.toDecimal(decimalPlaces))"
    let height: String = "\(self.y.toDecimal(decimalPlaces))"
    
    switch style {
      case .short:
        return "\(width) x \(height)"
        
      case .full:
        return "X \(width)  Y \(height)"
        
    }
  }
  
  enum StringStyle {
    case short
    case full
  }
  
  var isEmpty: Bool {
    x.isZero && y.isZero
  }
  
  var isZero: Bool {
    x.isZero && y.isZero
  }
  
  var isFinite: Bool {
    x.isFinite && y.isFinite
  }
  
  
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
    let copy = self
    return CGPoint(x: copy.x, y: copy.y - distance)
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
  
  
  /// Returns a point along the line defined by `start` and `end`.
  /// - Parameters:
  ///   - start: The starting point of the line.
  ///   - end: The ending point of the line.
  ///   - t: A factor determining the point's position along the line.
  ///        When t = 0, the result is `start`.
  ///        When t = 1, the result is `end`.
  ///        Values less than 0 or greater than 1 will extrapolate beyond the line segment.
  /// - Returns: A point along the line defined by `start` and `end`.
  static func pointAlong(from start: CGPoint, to end: CGPoint, t: CGFloat) -> CGPoint {
    return CGPoint(
      x: start.x + (end.x - start.x) * t,
      y: start.y + (end.y - start.y) * t
    )
  }
  
  /// Returns a point along the line from this point to `end`.
  /// - Parameters:
  ///   - end: The ending point of the line.
  ///   - t: A factor determining the point's position along the line.
  ///        When t = 0, the result is this point.
  ///        When t = 1, the result is `end`.
  ///        Values less than 0 or greater than 1 will extrapolate beyond the line segment.
  /// - Returns: A point along the line from this point to `end`.
  func pointAlong(to end: CGPoint, t: CGFloat) -> CGPoint {
    return CGPoint.pointAlong(from: self, to: end, t: t)
  }
  
  
  
  
  /// Returns a point at a specified distance along the line defined by `start` and `end`.
  /// - Parameters:
  ///   - start: The starting point of the line.
  ///   - end: The ending point of the line.
  ///   - distance: The absolute distance from the `start` point.
  /// - Returns: A point along the line defined by `start` and `end` at the specified distance.
  static func pointAlong(from start: CGPoint, to end: CGPoint, distance: CGFloat) -> CGPoint {
    let dx = end.x - start.x
    let dy = end.y - start.y
    let totalDistance = sqrt(dx * dx + dy * dy)
    
    // Calculate the unit vector in the direction from start to end
    let unitVectorX = dx / totalDistance
    let unitVectorY = dy / totalDistance
    
    // Calculate the new point at the specified distance
    return CGPoint(
      x: start.x + unitVectorX * distance,
      y: start.y + unitVectorY * distance
    )
  }
  
  
  
  
  /// Returns a point at a specified distance along the line from this point to `end`.
  /// - Parameters:
  ///   - end: The ending point of the line.
  ///   - distance: The absolute distance from this point.
  /// - Returns: A point along the line from this point to `end` at the specified distance.
  func pointAlong(to end: CGPoint, distance: CGFloat) -> CGPoint {
    return CGPoint.pointAlong(from: self, to: end, distance: distance)
  }
}
