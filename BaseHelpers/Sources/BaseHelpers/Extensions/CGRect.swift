//
//  CGRect.swift
//  Collection
//
//  Created by Dave Coleman on 9/12/2024.
//

import SwiftUI

public enum RectCorner {
  case topLeading, topTrailing, bottomLeading, bottomTrailing
}

/// ```
/// ● = origin
///
///                   midX
///                    |
/// minX,minY ● ───────|────────┐ maxX,minY
///           │                 │
///           │                 │
///           │                 │
///    midY --—      CGRect     --- midY
///           │                 │
///           │                 │
///           │                 │
/// minX,maxY └────────|────────┘ maxX,maxY
///                    |
///                   midX
///
/// ```
///
/// `UnitPoint` maps nicely to `CGRect`'s coordinate methods:
///
/// ```
/// minX, minY → topLeading
/// maxX, minY → topTrailing
/// minX, maxY → bottomLeading
/// maxX, maxY → bottomTrailing
/// midX, minY → top
/// minX, midY → leading
/// maxX, midY → trailing
/// midX, maxY → bottom
/// midX, midY → center
///
/// ```

extension CGRect {

  public var path: Path {
    Path(self)
  }

  public func point(for corner: RectCorner) -> CGPoint {
    switch corner {
      case .topLeading: CGPoint(x: minX, y: minY)
      case .topTrailing: CGPoint(x: maxX, y: minY)
      case .bottomLeading: CGPoint(x: minX, y: maxY)
      case .bottomTrailing: CGPoint(x: maxX, y: maxY)
    }
  }

  /// Get a CGPoint at the specified UnitPoint within this rect
  public func point(at unitPoint: UnitPoint) -> CGPoint {
    return CGPoint(
      x: minX + (unitPoint.x * width),
      y: minY + (unitPoint.y * height)
    )
  }

  public func edgePoints(for edge: Edge) -> (start: CGPoint, end: CGPoint) {
    switch edge {
      case .top: (CGPoint(x: minX, y: minY), CGPoint(x: maxX, y: minY))
      case .bottom: (CGPoint(x: minX, y: maxY), CGPoint(x: maxX, y: maxY))
      case .leading: (CGPoint(x: minX, y: minY), CGPoint(x: minX, y: maxY))
      case .trailing: (CGPoint(x: maxX, y: minY), CGPoint(x: maxX, y: maxY))
    }
  }

  /// Get a UnitPoint representing where a CGPoint falls within this rect
  /// - Parameter point: The CGPoint to convert
  /// - Returns: The normalized UnitPoint (may be outside 0.0-1.0 if point is outside rect)
  public func unitPoint(for point: CGPoint) -> UnitPoint {
    return UnitPoint(
      x: width > 0 ? (point.x - minX) / width : 0,
      y: height > 0 ? (point.y - minY) / height : 0
    )
  }

  /// Returns the centre point of this rectangle
  public var midpoint: CGPoint { center }

  /// Positions this rect inside the container, aligned according to the given UnitPoint.
  ///
  /// Note: This mirrors how alignment guides work in SwiftUI — the origin of the
  /// rect shifts so that the point described by anchor within the container aligns
  /// to the same point in the rect.
  public func aligned(
    in container: CGSize,
    to anchor: UnitPoint = .center
  ) -> CGRect {
    let origin = CGPoint(
      x: (container.width - width) * anchor.x,
      y: (container.height - height) * anchor.y
    )
    return CGRect(origin: origin, size: size)
  }

  public var toCGSize: CGSize {
    CGSize(width: width, height: height)
  }

  /// `CGRect` represents a rectangle in a 2D coordinate system.
  /// The `origin` property represents the starting point (or the top-left corner).
  ///
  /// `origin`A CGPoint that specifies the (x, y) coordinates of the rectangle's top-left corner.
  /// `minX` Equals `origin.x`, representing the left edge of the rectangle.
  /// `minY` Equals `origin.y`, representing the top edge of the rectangle.
  /// `maxX` Calculated as `origin.x + width`, representing the right edge of the rectangle.
  /// `maxY` Calculated as `origin.y + height`, representing the bottom edge of the rectangle.
  /// `width` The width of the rectangle, defined as `maxX - minX`.
  /// `height`The height of the rectangle, defined as `maxY - minY`.
  ///
  /// ### Summary
  /// -  The `origin` defines the position of the rectangle in the coordinate system.
  /// -  `minX` and `minY` are directly derived from the `origin`.
  /// -  The dimensions (`width` and `height`) are used in conjunction with the
  /// `origin` to determine the rectangle's boundaries (`maxX` and `maxY`).


  // MARK: - Common UnitPoint Positions as CGPoints

  /// Top-left corner (minX, minY)
  public var topLeading: CGPoint { point(at: .topLeading) }

  /// Top-center (midX, minY)
  public var top: CGPoint { point(at: .top) }

  /// Top-right corner (maxX, minY)
  public var topTrailing: CGPoint { point(at: .topTrailing) }

  /// Center-left (minX, midY)
  public var leading: CGPoint { point(at: .leading) }

  /// Dead center (midX, midY)
  public var center: CGPoint { point(at: .center) }

  /// Center-right (maxX, midY)
  public var trailing: CGPoint { point(at: .trailing) }

  /// Bottom-left corner (minX, maxY)
  public var bottomLeading: CGPoint { point(at: .bottomLeading) }

  /// Bottom-center (midX, maxY)
  public var bottom: CGPoint { point(at: .bottom) }

  /// Bottom-right corner (maxX, maxY)
  public var bottomTrailing: CGPoint { point(at: .bottomTrailing) }

  // Edges
  public var leadingEdge: CGFloat { minX }
  public var trailingEdge: CGFloat { maxX }
  public var topEdge: CGFloat { minY }
  public var bottomEdge: CGFloat { maxY }

  
  // Dimensions
  public var horizontal: ClosedRange<CGFloat> { minX...maxX }
  public var vertical: ClosedRange<CGFloat> { minY...maxY }

  // Initialization helpers
//  public static func between(point1: CGPoint, point2: CGPoint) -> CGRect {
//    let minX = min(point1.x, point2.x)
//    let minY = min(point1.y, point2.y)
//    let maxX = max(point1.x, point2.x)
//    let maxY = max(point1.y, point2.y)
//
//    return CGRect(
//      x: minX,
//      y: minY,
//      width: maxX - minX,
//      height: maxY - minY
//    )
//  }

  /// Returns a rectangle that encompasses both this rectangle and the provided rectangle
  public func expanded(toInclude rect: CGRect) -> CGRect {
    return union(rect)  // Use built-in union method
  }
  
  /// Creates a rectangle from two points, ensuring positive width and height
  /// Useful for drag operations like marquee selection where the drag direction is unknown
  ///
  /// Note: previous methods `reversible`, `fromPoints(_:_:)`,
  /// `between(point1:point2:)`
  public static func boundingRect(
    from start: CGPoint,
    to end: CGPoint
  ) -> CGRect {
    return CGRect(
      x: min(start.x, end.x),
      y: min(start.y, end.y),
      width: abs(end.x - start.x),
      height: abs(end.y - start.y)
    )
  }

  /// Creates a rectangle with the given size, centered within the container size
  public init(size: CGSize, centeredIn containerSize: CGSize) {
    let origin = CGPoint(
      x: (containerSize.width - size.width) / 2,
      y: (containerSize.height - size.height) / 2
    )
    self.init(origin: origin, size: size)
  }

  /// Useful for occasions where origin and size properties
  /// are already defined, just need to be plugged in,
  /// and an extra-quick init is helpful
  public init(_ origin: CGPoint, _ size: CGSize) {
    self.init(origin: origin, size: size)
  }

  public static let exampleZeroOrigin100x100 = CGRect(
    x: 0,
    y: 0,
    width: 100,
    height: 100
  )

}
