//
//  CGPoint.swift
//  Collection
//
//  Created by Dave Coleman on 16/11/2024.
//

import SwiftUI

// MARK: - Subtraction
infix operator - : AdditionPrecedence

public func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  return CGPoint(
    x: lhs.x - rhs.x,
    y: lhs.y - rhs.y
  )
}

public func - (lhs: CGPoint, rhs: CGSize) -> CGPoint {
  return CGPoint(
    x: lhs.x - rhs.width,
    y: lhs.y - rhs.height
  )
}

// MARK: - Addition
infix operator + : AdditionPrecedence

public func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  return CGPoint(
    x: lhs.x + rhs.x,
    y: lhs.y + rhs.y
  )
}

public func + (lhs: CGPoint, rhs: CGSize) -> CGPoint {
  return CGPoint(
    x: lhs.x + rhs.width,
    y: lhs.y + rhs.height
  )
}

// MARK: - Multiplication
infix operator * : MultiplicationPrecedence

public func * (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  return CGPoint(
    x: lhs.x * rhs.x,
    y: lhs.y * rhs.y
  )
}

public func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
  return CGPoint(
    x: lhs.x * rhs,
    y: lhs.y * rhs
  )
}

// MARK: - Plus Equals
infix operator += : AssignmentPrecedence

public func += (lhs: inout CGPoint, rhs: CGPoint) {
  lhs = lhs + rhs
}

public func += (lhs: inout CGPoint, rhs: CGSize) {
  lhs = lhs + rhs
}

// MARK: - Minus Equals
infix operator -= : AssignmentPrecedence

public func -= (lhs: inout CGPoint, rhs: CGPoint) {
  lhs = lhs - rhs
}

public func -= (lhs: inout CGPoint, rhs: CGSize) {
  lhs = lhs - rhs
}


// MARK: - Greater than
infix operator > : ComparisonPrecedence

public func > (lhs: CGPoint, rhs: CGPoint) -> Bool {
  lhs.x > rhs.x || lhs.y > rhs.y
}

// MARK: - Less than
infix operator < : ComparisonPrecedence

public func < (lhs: CGPoint, rhs: CGPoint) -> Bool {
  lhs.x < rhs.x || lhs.y < rhs.y
}


//public func -(lhs: CGPoint, rhs: CGSize) -> CGPoint {
//  return CGPoint(x: lhs.x - rhs.width, y: lhs.y - rhs.height)
//}

extension CGPoint {

  public var normalised: CGPoint {
    let length = sqrt(x * x + y * y)
    guard length > 0 else { return .zero }
    return CGPoint(
      x: x / length,
      y: y / length
    )
  }

  public func distance(to point: CGPoint) -> CGFloat {
    sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
  }
  
  /// Where `self` is a normalised point
  ///
  /// Example usage:
  /// ```
  /// let touchPos = convertNormalizedToConcrete(
  ///   normalizedPoint: touch.position,
  ///   in: trackPadSize
  /// )
  /// ```
  public func convertNormalisedToConcrete(
    in size: CGSize,
    origin: CGPoint = .zero
  ) -> CGPoint {
    return CGPoint(
      x: origin.x + (self.x * size.width),
      y: origin.y + (self.y * size.height)
    )
  }

  // Useful for determining drag direction
  //  func direction(to point: CGPoint) -> SwiftUI.Direction {
  //    let deltaX = point.x - x
  //    let deltaY = point.y - y
  //    let angle = atan2(deltaY, deltaX)
  //
  //    // Convert angle to degrees and normalize to 0-360
  //    let degrees = (angle * 180 / .pi + 360).truncatingRemainder(dividingBy: 360)
  //
  //    switch degrees {
  //      case 0..<45, 315..<360: return .right
  //      case 45..<135: return .down
  //      case 135..<225: return .left
  //      case 225..<315: return .up
  //      default: return .right
  //    }
  //  }


  public func removingZoom(_ zoom: CGFloat) -> CGPoint {
    CGPoint(x: self.x / zoom, y: self.y / zoom)
  }

  public func subtracting(_ point: CGPoint) -> CGPoint {
    return CGPoint(x: self.x - point.x, y: self.y - point.y)
  }

  public func subtracting(_ size: CGSize) -> CGPoint {
    return CGPoint(x: self.x - size.width, y: self.y - size.height)
  }

  public func adding(_ point: CGPoint) -> CGPoint {
    return CGPoint(
      x: self.x + point.x,
      y: self.y + point.y
    )
  }

  public func multiplying(by value: CGFloat) -> CGPoint {
    return CGPoint(x: self.x * value, y: self.y * value)
  }

  public var toCGSize: CGSize {
    return CGSize(width: self.x, height: self.y)
  }

  public func clamp(_ maxValue: CGFloat) -> CGPoint {
    return CGPoint(
      x: max(-maxValue, min(maxValue, self.x)),
      y: max(-maxValue, min(maxValue, self.y))
    )
  }

  public func delta(
    from lastPosition: CGPoint,
    sensitivity: CGFloat = 1.0
  ) -> CGPoint {
    let result = CGPoint(
      x: (self.x - lastPosition.x) * sensitivity,
      y: (self.y - lastPosition.y) * sensitivity
    )

    return result
  }

  public func unitPoint(in size: CGSize) -> UnitPoint {
    guard size.width > 0 && size.height > 0 else {
      return .center  // or another reasonable default
    }

    return UnitPoint(x: x / size.width, y: y / size.height)
  }

  public func displayString(decimalPlaces: Int = 2) -> String {
    return "\(self.x.toDecimal(decimalPlaces)) x \(self.y.toDecimal(decimalPlaces))"
  }

  public func displayString(decimalPlaces: Int = 2, style: DisplayStringStyle = .short) -> String {

    let width: String = "\(self.x.toDecimal(decimalPlaces))"
    let height: String = "\(self.y.toDecimal(decimalPlaces))"

    switch style {
      case .short:
        return "\(width) x \(height)"

      case .full:
        return "X \(width)  Y \(height)"

    }
  }

  public enum DisplayStringStyle {
    case short
    case full
  }

  public var isEmpty: Bool {
    x.isZero && y.isZero
  }

  public var isZero: Bool {
    x.isZero && y.isZero
  }

  public var isFinite: Bool {
    x.isFinite && y.isFinite
  }

  public var isNan: Bool {
    let result: Bool = x.isNaN || y.isNaN
    print("Point `\(self)` is Not a Number? (NaN): \(result)")
    return result
  }


  // Shift right (increases x)
  public func shiftRight(_ distance: CGFloat) -> CGPoint {
    return CGPoint(x: self.x + distance, y: self.y)
  }

  // Shift left (decreases x)
  public func shiftLeft(_ distance: CGFloat) -> CGPoint {
    return CGPoint(x: self.x - distance, y: self.y)
  }

  // Shift down (increases y)
  public func shiftDown(_ distance: CGFloat) -> CGPoint {
    return CGPoint(x: self.x, y: self.y + distance)
  }

  // Shift up (decreases y)
  public func shiftUp(_ distance: CGFloat) -> CGPoint {
    let copy = self
    return CGPoint(x: copy.x, y: copy.y - distance)
  }

  // Shift diagonally
  public func shift(dx: CGFloat, dy: CGFloat) -> CGPoint {
    return CGPoint(x: self.x + dx, y: self.y + dy)
  }

  // Shift by another point
  public func shift(by point: CGPoint) -> CGPoint {
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
  public static func pointAlong(from start: CGPoint, to end: CGPoint, t: CGFloat) -> CGPoint {
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
  public func pointAlong(to end: CGPoint, t: CGFloat) -> CGPoint {
    return CGPoint.pointAlong(from: self, to: end, t: t)
  }


  /// Returns a point at a specified distance along the line defined by `start` and `end`.
  /// - Parameters:
  ///   - start: The starting point of the line.
  ///   - end: The ending point of the line.
  ///   - distance: The absolute distance from the `start` point.
  /// - Returns: A point along the line defined by `start` and `end` at the specified distance.
  public static func pointAlong(from start: CGPoint, to end: CGPoint, distance: CGFloat) -> CGPoint {
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
  public func pointAlong(to end: CGPoint, distance: CGFloat) -> CGPoint {
    return CGPoint.pointAlong(from: self, to: end, distance: distance)
  }
}
