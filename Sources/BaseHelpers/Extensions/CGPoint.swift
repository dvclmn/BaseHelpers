//
//  CGPoint.swift
//  Collection
//
//  Created by Dave Coleman on 16/11/2024.
//

import SwiftUI

public enum ResizeMode {
  /// Fill destination rect exactly, even if aspect ratio is distorted
  case stretch

  /// Contain: scale uniformly to fit within destination (aspect ratio preserved)
  case fit

  /// Cover: scale uniformly to cover entire destination (aspect ratio preserved, may clip)
  case fill
}

extension CGPoint {

  public func removingPanAndZoom(pan: CGSize, zoom: CGFloat) -> CGPoint {
    let unPanned: CGPoint = self - pan
    let unZoomed: CGPoint = unPanned / zoom
    return unZoomed
  }

  // MARK: - UnitPoint
  public func debugColour(unitPoint: UnitPoint, in size: CGSize) -> Color {
    guard self.isNear(unitPoint: unitPoint, in: size) else {
      return Color.clear
    }
    return unitPoint.debugColour
  }

  public func isNear(
    unitPoint: UnitPoint,
    in size: CGSize,
    threshold: CGFloat = 10
  ) -> Bool {
    let targetPoint = unitPoint.toCGPoint(in: size)
    return self.distance(to: targetPoint) <= threshold
  }

  public var isGreaterThanOrEqualToZero: Bool {
    return x >= 0 && y >= 0
  }

  public var isGreaterThanZero: Bool {
    return x > 0 && y > 0
  }

  //  public func toUnitPoint(in size: CGSize) -> UnitPoint {
  //    guard size.isPositive else {
  //      return .center
  //    }
  //
  //    return UnitPoint(x: x / size.width, y: y / size.height)
  //  }
  //

  /// Returns the relative UnitPoint (not snapped) within a given size.
  ///
  /// Usage:
  /// ```
  /// let point = CGPoint(x: 10, y: 5)
  /// let frameSize = CGSize(width: 100, height: 100)
  ///
  /// let closestAnchor = point.nearestAnchor(in: frameSize)
  /// print(closestAnchor)  // Might print `.topLeading` if point is near (0,0)
  /// ```
  public func toUnitPoint(in size: CGSize) -> UnitPoint {
    guard size.isGreaterThanOrEqualToZero else { return .center }
    return UnitPoint(x: x / size.width, y: y / size.height)
  }

  /// Returns a new CGPoint aligned relative to a container of the given size,
  /// using a unit point as the anchor.
  ///
  /// Important: For this one, think of `self` as an offset or adjustment to be
  /// applied relative to the anchor point described by the `unitPoint`.
  ///
  /// For example, if you wanted to place something 10pts to the right and 5pts
  /// below the bottomTrailing of a 300×400 container:
  /// ```
  /// let offset = CGPoint(x: 10, y: 5)
  /// let result = offset.aligned(to: .bottomTrailing, in: CGSize(width: 300, height: 400))
  /// // → CGPoint(x: 310, y: 405)
  /// ```
  public func aligned(
    to unitPoint: UnitPoint,
    in containerSize: CGSize
  ) -> CGPoint {
    let anchor = CGPoint(
      x: unitPoint.x * containerSize.width,
      y: unitPoint.y * containerSize.height
    )
    return CGPoint(x: anchor.x + self.x, y: anchor.y + self.y)
  }

  /// Alternative to above `aligned(to:,in:)`
  /// This is aligning a `CGPoint` within a container, based on anchor.
  /// Aka shifts the current point so that it lands at the target anchor.
  ///
  /// Returns a new point positioned within a container so that this point
  /// becomes aligned to the specified anchor.
  public func repositioned(
    to unitPoint: UnitPoint,
    in containerSize: CGSize
  ) -> CGPoint {
    let anchor = CGPoint(
      x: unitPoint.x * containerSize.width,
      y: unitPoint.y * containerSize.height)
    return CGPoint(x: anchor.x - self.x, y: anchor.y - self.y)
  }

  /// Returns the closest named UnitPoint (e.g., .topLeading, .center, etc) within a given size.
  /// If the point is within a central region defined by tolerance, `.center` is returned.
  public func nearestAnchor(
    in size: CGSize,
    centerTolerance: CGFloat = 0.2
  ) -> UnitPoint {
    let relative = toUnitPoint(in: size)

    /// If close enough to center, return .center early
    let center = UnitPoint.center
    let dx = abs(relative.x - center.x)
    let dy = abs(relative.y - center.y)

    if dx <= centerTolerance / 2 && dy <= centerTolerance / 2 {
      return .center
    }

    let anchors: [UnitPoint] = [
      .topLeading, .top, .topTrailing,
      .leading, .trailing,
      .bottomLeading, .bottom, .bottomTrailing,
    ]

    func distanceSquared(from a: UnitPoint, to b: UnitPoint) -> CGFloat {
      let dx = a.x - b.x
      let dy = a.y - b.y
      return dx * dx + dy * dy
    }

    return anchors.min(by: {
      distanceSquared(from: relative, to: $0) < distanceSquared(from: relative, to: $1)
    }) ?? .center
  }

  public init(fromSize size: CGSize) {
    self.init(x: size.width, y: size.height)
  }
  public init(fromLength length: CGFloat) {
    self.init(x: length, y: length)
  }

  public func isWithin(size: CGSize) -> Bool {
    return self.x >= 0
      || self.x < size.width
      || self.y >= 0
      || self.y < size.height
  }

  /// Assumes top-left anchor for origin
  public func isWithin(_ rect: CGRect) -> Bool {
    let isXWithin: Bool = self.x >= rect.leadingEdge && self.x <= rect.trailingEdge
    let isYWithin: Bool = self.y >= rect.topEdge && self.y <= rect.bottomEdge

    return isXWithin && isYWithin
  }

  public static let quickPreset01 = CGPoint(x: 100, y: 50)
  public static let quickPreset02 = CGPoint(x: 80, y: 120)

  // MARK: - Stretch out an Axis
  public struct StretchOptions: OptionSet, Sendable {
    public let rawValue: Int
    static let normalised = StretchOptions(rawValue: 1 << 0)
    public static let clamped = StretchOptions(rawValue: 1 << 0)

    public init(rawValue: Int) {
      self.rawValue = rawValue
    }
  }

  public func centredIn(size: CGSize) -> CGPoint {
    let centred: CGSize = size / 2
    return self - centred
  }

  /// Map cursorX to a stretched range
  ///
  /// The utility of this may not be obvious at first glance, so here's a simple example.
  /// For my `.hover3DEffect()` modifier, I wanted the range of movement
  /// (along the x axis) for the 'glint' effect, to be *wider* than the pointer's actual
  /// range, across the surface of the view. This maps an axis of a CGPoint to be wider
  /// (or narrower) than the original.
  public func stretchedPosition(
    _ axis: Axis,
    in size: CGSize,
    stretchFactor: CGFloat,
    options: StretchOptions = []
  ) -> CGFloat {

    let rawLocation: CGFloat =
      switch axis {
        case .horizontal: self.x
        case .vertical: self.y
      }

    let viewLength: CGFloat =
      switch axis {
        case .horizontal: size.width
        case .vertical: size.height
      }

    let normalisedValue = options.contains(.normalised) ? rawLocation / viewLength : rawLocation

    let centered: CGFloat
    let result: CGFloat

    if options.contains(.normalised) {
      centered = normalisedValue - 0.5
      result = centered * stretchFactor + 0.5
    } else {
      centered = rawLocation - (viewLength / 2)
      result = centered * stretchFactor + (viewLength / 2)
    }

    if options.contains(.clamped) {
      return result.clamped(to: 0...1)
    }

    return result
  }

  public var normalised: CGPoint {
    guard length > 0 else { return .zero }
    return CGPoint(
      x: x / length,
      y: y / length
    )
  }

  public var length: CGFloat {
    /// Previously: `sqrt(x * x + y * y)`
    hypot(x, y)
  }

  /// Below is equivalent to a previous version, which used
  /// `sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))`
  ///
  /// This calculates Euclidean distance (straight-line distance)
  public func distance(to p2: CGPoint) -> CGFloat {
    let p1: CGPoint = self
    return hypot(p2.x - p1.x, p2.y - p1.y)
  }

  /// Returns true if both x and y coordinates are in the range [0.0, 1.0]
  public var isNormalised: Bool {
    return x >= 0.0 && x <= 1.0 && y >= 0.0 && y <= 1.0
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

  /// Hint: use extension `toCGRect` on `CGSize` for convenient
  /// conversion, if origin is `zero`.
  public func mapped(to destination: CGRect) -> CGPoint {
    let result = CGPoint(
      x: destination.origin.x + (self.x * destination.width),
      y: destination.origin.y + (self.y * destination.height)
    )
    return result
  }

  public func remapped(from oldRect: CGRect, to newRect: CGRect) -> CGPoint {
    let normalisedX = (self.x - oldRect.minX) / oldRect.width
    let normalisedY = (self.y - oldRect.minY) / oldRect.height

    let newX = newRect.minX + (normalisedX * newRect.width)
    let newY = newRect.minY + (normalisedY * newRect.height)

    return CGPoint(x: newX, y: newY)
  }

  public func mapPoint(
    from source: CGRect,
    to destination: CGRect,
    mode: ResizeMode = .fit
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
    return self / zoom
  }

  func removingZoomPercent(_ zoomPercent: CGFloat) -> CGPoint {
    let adjustedX = self.x.removingZoomPercent(zoomPercent)
    let adjustedY = self.y.removingZoomPercent(zoomPercent)
    return CGPoint(x: adjustedX, y: adjustedY)
  }

  public var toCGSize: CGSize {
    return CGSize(width: self.x, height: self.y)
  }

  @available(*, deprecated, message: "Not sure this makes sense, consider revising.")
  public func clamp(toMax maxValue: CGFloat) -> CGPoint {
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

  public var isZero: Bool {
    x.isZero && y.isZero
  }

  public var isFinite: Bool {
    x.isFinite && y.isFinite
  }

  public var hasValidValue: Bool {
    return !isNan && isFinite
  }

  public var isNan: Bool {
    x.isNaN || y.isNaN
  }

  /// Shift right (increases x)
  public func shiftedRight(_ distance: CGFloat) -> CGPoint {
    return CGPoint(x: self.x + distance, y: self.y)
  }

  /// Shift left (decreases x)
  public func shiftedLeft(_ distance: CGFloat) -> CGPoint {
    return CGPoint(x: self.x - distance, y: self.y)
  }

  /// Shift down (increases y)
  public func shiftedDown(_ distance: CGFloat) -> CGPoint {
    return CGPoint(x: self.x, y: self.y + distance)
  }

  /// Shift up (decreases y)
  public func shiftedUp(_ distance: CGFloat) -> CGPoint {
    let copy = self
    return CGPoint(x: copy.x, y: copy.y - distance)
  }

  /// Shift diagonally
  public func shifted(dx: CGFloat, dy: CGFloat) -> CGPoint {
    return CGPoint(x: self.x + dx, y: self.y + dy)
  }

  /// Shift by another point
  public func shifted(by point: CGPoint) -> CGPoint {
    return CGPoint(x: self.x + point.x, y: self.y + point.y)
  }
  public func shifted(by offset: CGSize) -> CGPoint {
    return CGPoint(
      x: self.x + offset.width,
      y: self.y + offset.height
    )
  }

  /// Shift by the same value in both directions
  public func shifted(by delta: CGFloat) -> CGPoint {
    return CGPoint(x: self.x + delta, y: self.y + delta)
  }

  public static func midPoint(
    from p1: CGPoint,
    to p2: CGPoint
  ) -> CGPoint {
    return pointAlong(from: p1, to: p2, t: 0.5)
  }

  public func applyPanAndZoom(pan: CGSize, zoom: CGFloat) -> CGPoint {
    let scaled = CGPoint(
      x: x * zoom,
      y: y * zoom
    )
    let translated = CGPoint(
      x: scaled.x + pan.width,
      y: scaled.y + pan.height
    )
    return translated
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
  public static func pointAlong(
    from start: CGPoint,
    to end: CGPoint,
    distance: CGFloat
  ) -> CGPoint {
    let dx = end.x - start.x
    let dy = end.y - start.y
    let totalDistance = sqrt(dx * dx + dy * dy)

    /// Calculate the unit vector in the direction from start to end
    let unitVectorX = dx / totalDistance
    let unitVectorY = dy / totalDistance

    /// Calculate the new point at the specified distance
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

  /// Generate a spiral as an array of points, starting from this point as center
  public func generateSpiral(
    turns: CGFloat = 1.5,
    maxRadius: CGFloat = 50,
    pointCount: Int = 60
  ) -> [CGPoint] {
    var points: [CGPoint] = []

    let angleStep = (turns * 2 * .pi) / CGFloat(pointCount - 1)

    for i in 0..<pointCount {
      let t = CGFloat(i) / CGFloat(pointCount - 1)  // 0 to 1
      let angle = angleStep * CGFloat(i)

      // Spiral grows outward as we progress
      let radius = maxRadius * t

      let x = self.x + radius * cos(angle)
      let y = self.y + radius * sin(angle)

      points.append(CGPoint(x: x, y: y))
    }

    return points
  }

  /// Alternative: Golden ratio spiral (more mathematically pure)
  public func generateGoldenSpiral(
    turns: CGFloat = 1.5,
    scale: CGFloat = 20,
    pointCount: Int = 60
  ) -> [CGPoint] {
    var points: [CGPoint] = []
    let phi: CGFloat = (1 + sqrt(5)) / 2  // Golden ratio

    for i in 0..<pointCount {
      let t = CGFloat(i) / CGFloat(pointCount - 1) * turns
      let angle = t * 2 * .pi

      // Golden spiral radius grows exponentially
      let radius = scale * pow(phi, t * 0.5)

      let x = self.x + radius * cos(angle)
      let y = self.y + radius * sin(angle)

      points.append(CGPoint(x: x, y: y))
    }

    return points
  }

}

public enum PathType {
  case line
  case smooth
}

extension Array where Element == CGPoint {

  public func toPath(type: PathType = .line) -> Path {
    switch type {
      case .line:
        return Path { path in
          guard let firstPoint = self.first else { return }
          path.move(to: firstPoint)
          path.addLines(Array(self.dropFirst()))
        }

      case .smooth:
        return toSmoothPath()
    }
  }

  /// Alternative: Smooth curved path using quadratic curves
  func toSmoothPath() -> Path {
    return Path { path in
      guard self.count > 1 else { return }

      path.move(to: self[0])

      if self.count == 2 {
        path.addLine(to: self[1])
        return
      }

      // Create smooth curves between points
      for i in 1..<self.count {
        let current = self[i]

        if i == self.count - 1 {
          // Last point - just draw line
          path.addLine(to: current)
        } else {
          // Use next point to create control point for smooth curve
          let next = self[i + 1]
          let controlPoint = CGPoint(
            x: (current.x + next.x) / 2,
            y: (current.y + next.y) / 2
          )
          path.addQuadCurve(to: controlPoint, control: current)
        }
      }
    }
  }

}

// MARK: - Subtraction

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

public func - (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
  return CGPoint(
    x: lhs.x - rhs,
    y: lhs.y - rhs
  )
}

// MARK: - Addition

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

public func + (lhs: CGSize, rhs: CGPoint) -> CGPoint {
  return CGPoint(
    x: lhs.width + rhs.x,
    y: lhs.height + rhs.y
  )
}

public func + (lhs: CGSize, rhs: CGPoint) -> CGSize {
  return CGSize(
    width: lhs.width + rhs.x,
    height: lhs.height + rhs.y
  )
}

public func + (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
  return CGPoint(
    x: lhs.x + rhs,
    y: lhs.y + rhs
  )
}

public func += (lhs: inout CGPoint, rhs: CGPoint) {
  lhs = lhs + rhs
}

public func += (lhs: inout CGPoint, rhs: CGSize) {
  lhs = lhs + rhs
}

// MARK: - Minus Equals

public func -= (lhs: inout CGPoint, rhs: CGPoint) {
  lhs = lhs - rhs
}

public func -= (lhs: inout CGPoint, rhs: CGSize) {
  lhs = lhs - rhs
}

// MARK: - Multiplication

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
public func * (lhs: CGPoint, rhs: CGSize) -> CGPoint {
  return CGPoint(
    x: lhs.x * rhs.width,
    y: lhs.y * rhs.height
  )
}

public func / (lhs: CGPoint, rhs: CGSize) -> CGPoint {
  precondition(rhs.width != 0 && rhs.height != 0, "Cannot divide by zero size")
  return CGPoint(
    x: lhs.x / rhs.width,
    y: lhs.y / rhs.height
  )
}
public func / (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
  precondition(rhs != 0 && rhs != 0, "Cannot divide by zero size")
  return CGPoint(
    x: lhs.x / rhs,
    y: lhs.y / rhs
  )
}

// MARK: - Plus Equals

// MARK: - Greater than
/// These can be too ambiguous (use of `||` or `&&`?)
/// See `CGSize` for better approach
//public func > (lhs: CGPoint, rhs: CGPoint) -> Bool {
//  lhs.x > rhs.x || lhs.y > rhs.y
//}
//
//// MARK: - Less than
//
//public func < (lhs: CGPoint, rhs: CGPoint) -> Bool {
//  lhs.x < rhs.x || lhs.y < rhs.y
//}
