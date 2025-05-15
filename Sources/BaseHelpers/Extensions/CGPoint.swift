//
//  CGPoint.swift
//  Collection
//
//  Created by Dave Coleman on 16/11/2024.
//

import SwiftUI


public enum CoordinateMappingMode {
  /// Fill destination rect exactly, even if aspect ratio is distorted
  case stretch
  
  /// Contain: scale uniformly to fit within destination (aspect ratio preserved)
  case fit
  
  /// Cover: scale uniformly to cover entire destination (aspect ratio preserved, may clip)
  case fill
  
}

extension CGPoint {
  
  public static let quickPreset01 = CGPoint(x: 100, y: 50)
  public static let quickPreset02 = CGPoint(x: 80, y: 120)
  

  public var length: CGFloat {
    sqrt(x * x + y * y)
  }

  public var normalised: CGPoint {
    guard length > 0 else { return .zero }
    return CGPoint(
      x: x / length,
      y: y / length
    )
  }
  

  /// Below is equivalent to a previous version, which used
  /// `sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))`
  public func distance(to p2: CGPoint) -> CGFloat {
    let p1: CGPoint = self
    return hypot(p2.x - p1.x, p2.y - p1.y)
  }

  public func distance(to p2: CGPoint?) -> CGFloat? {
    guard let p2 else { return nil }
    let p1: CGPoint = self
    return hypot(p2.x - p1.x, p2.y - p1.y)
  }
  
  public static func angleInRadians(
    from p1: CGPoint,
    to p2: CGPoint
  ) -> CGFloat {
    atan2(p2.y - p1.y, p2.x - p1.x)
  }
  
  public static func angle(from p1: CGPoint, to p2: CGPoint) -> Angle {
    Angle(radians: angleInRadians(from: p1, to: p2))
  }

//  public static func angleBetween(
//    _ p1: CGPoint,
//    _ p2: CGPoint
//  ) -> CGFloat {
//    atan2(p2.y - p1.y, p2.x - p1.x)
//  }
  
  
  /// Hint: use extension `toCGRect` on `CGSize` for convenient
  /// conversion, if origin is `zero`.
  public func mapped(to destination: CGRect) -> CGPoint {
    let result = CGPoint(
      x: destination.origin.x + (x * destination.width),
      y: destination.origin.y + (y * destination.height)
    )
    return result
  }

  public func mapPoint(
    from source: CGRect,
    to destination: CGRect,
    mode: CoordinateMappingMode = .stretch
  ) -> CGPoint {
    switch mode {
      case .stretch:
        return stretchMap(from: source, to: destination)
      case .fit:
        return aspectFitMap(from: source, to: destination)
      case .fill:
        return aspectFillMap(from: source, to: destination)
    }
  }
  
  private func stretchMap(from source: CGRect, to destination: CGRect) -> CGPoint {
    let scaleX = destination.width / source.width
    let scaleY = destination.height / source.height
    
    let translatedX = (self.x - source.minX) * scaleX + destination.minX
    let translatedY = (self.y - source.minY) * scaleY + destination.minY
    
    return CGPoint(x: translatedX, y: translatedY)
  }
  
  private func aspectFitMap(from source: CGRect, to destination: CGRect) -> CGPoint {
    let fittedRect = aspectMappedRect(from: source, to: destination, fill: false)
    return stretchMap(from: source, to: fittedRect)
  }
  
  private func aspectFillMap(from source: CGRect, to destination: CGRect) -> CGPoint {
    let filledRect = aspectMappedRect(from: source, to: destination, fill: true)
    return stretchMap(from: source, to: filledRect)
  }
  
  private func aspectMappedRect(
    from source: CGRect,
    to destination: CGRect,
    fill: Bool
  ) -> CGRect {
    let sourceAspect = source.width / source.height
    let destAspect = destination.width / destination.height
    
    var scale: CGFloat
    var size: CGSize
    var origin: CGPoint
    
    if (fill && sourceAspect < destAspect) || (!fill && sourceAspect > destAspect) {
      // Width-constrained
      scale = destination.width / source.width
      size = CGSize(width: destination.width, height: source.height * scale)
      origin = CGPoint(
        x: destination.minX,
        y: destination.minY + (destination.height - size.height) / 2
      )
    } else {
      // Height-constrained
      scale = destination.height / source.height
      size = CGSize(width: source.width * scale, height: destination.height)
      origin = CGPoint(
        x: destination.minX + (destination.width - size.width) / 2,
        y: destination.minY
      )
    }
    
    return CGRect(origin: origin, size: size)
  }
  
  

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
  
  public var displayString: String {
    self.displayString(style: .full)
  }

  public func displayString(decimalPlaces: Int = 2) -> String {
    return "\(self.x.displayString(decimalPlaces)) x \(self.y.displayString(decimalPlaces))"
  }

  public func displayString(decimalPlaces: Int = 2, style: DisplayStringStyle = .short) -> String {

    let width: String = "\(self.x.displayString(decimalPlaces))"
    let height: String = "\(self.y.displayString(decimalPlaces))"

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
  
  public static func midPoint(
    from p1: CGPoint,
    to p2: CGPoint
  ) -> CGPoint {
    return pointAlong(from: p1, to: p2, t: 0.5)
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
  
  
  /// Where `self` is a normalised point
  ///
  /// Example usage:
  /// ```
  /// let touchPos = convertNormalizedToConcrete(
  ///   in: trackPadSize
  /// )
  /// ```
  @available(*, deprecated, renamed: "mapped(to:)", message: "Naming and use is a bit unclear.")
  public func convertNormalisedToConcrete(
    in size: CGSize,
    origin: CGPoint = .zero
  ) -> CGPoint {
    return CGPoint(
      x: origin.x + (self.x * size.width),
      y: origin.y + (self.y * size.height)
    )
  }

}



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

