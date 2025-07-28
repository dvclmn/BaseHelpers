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

extension CGRect {

  public func point(for corner: RectCorner) -> CGPoint {
    switch corner {
      case .topLeading: CGPoint(x: minX, y: minY)
      case .topTrailing: CGPoint(x: maxX, y: minY)
      case .bottomLeading: CGPoint(x: minX, y: maxY)
      case .bottomTrailing: CGPoint(x: maxX, y: maxY)
    }
  }

  public func edgePoints(for edge: RectEdge) -> (start: CGPoint, end: CGPoint) {
    switch edge {
      case .top:
        return (CGPoint(x: minX, y: minY), CGPoint(x: maxX, y: minY))
      case .bottom:
        return (CGPoint(x: minX, y: maxY), CGPoint(x: maxX, y: maxY))
      case .left:
        return (CGPoint(x: minX, y: minY), CGPoint(x: minX, y: maxY))
      case .right:
        return (CGPoint(x: maxX, y: minY), CGPoint(x: maxX, y: maxY))
    }
  }

  //  public var minXminY: CGPoint { CGPoint(x: minX, y: minY) }
  //  public var maxXminY: CGPoint { CGPoint(x: maxX, y: minY) }
  //  public var minXmaxY: CGPoint { CGPoint(x: minX, y: maxY) }
  //  public var maxXmaxY: CGPoint { CGPoint(x: maxX, y: maxY) }
  //
  //  /// Important: Below methods assume origin is top-left
  //  public var topLeadingCorner: CGPoint { CGPoint(x: minX, y: minY) }
  //  public var topTrailingCorner: CGPoint { CGPoint(x: maxX, y: minY) }
  //  public var bottomLeadingCorner: CGPoint { CGPoint(x: minX, y: maxY) }
  //  public var bottomTrailingCorner: CGPoint { CGPoint(x: maxX, y: maxY) }
  //  public var center: CGPoint { CGPoint(x: midX, y: midY) }

  public var path: Path {
    Path(self)
  }

  /// Returns the centre point of this rectangle
  public var midpoint: CGPoint {
    CGPoint(x: midX, y: midY)
  }

  /// Returns a new rect with the same size, but positioned so it's centred in the given size
  //  public func centred(in container: CGSize) -> CGRect {
  //    let origin = CGPoint(
  //      x: (container.width - width) / 2,
  //      y: (container.height - height) / 2
  //    )
  //    return CGRect(origin: origin, size: size)
  //  }

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
      x: (container.width - self.width) * anchor.x,
      y: (container.height - self.height) * anchor.y
    )
    return CGRect(origin: origin, size: self.size)
  }

  /// Returns the point you'd pass to `.position()` to centre this rect within the given size
  /// (i.e. the centre of the centred rect)
  //  public func centrePosition(in container: CGSize) -> CGPoint {
  //    centred(in: container).midpoint
  //  }

  //  /// This can be made better, but got this because SwiftUI's `.position()`
  //  /// modifier places the *centre* of the view at the origin. If the origin is
  //  /// meant to be the top leading corner, then this can help compensate for that.
  //  public func centeredIn(size: CGSize) -> CGRect {
  //
  //    let viewMid = size.midpoint
  //    let selfMid = self.size.midpoint
  //
  //    let newOrigin = CGPoint(
  //      x: viewMid.x - selfMid.x,
  //      y: viewMid.y - selfMid.y
  //    )
  //
  //    return CGRect(
  //      x: newOrigin.x,
  //      y: newOrigin.y,
  //      width: self.width,
  //      height: self.height
  //    )
  //  }
  //
  //  public func reallyCentredIn(size: CGSize) -> CGPoint {
  //    self.centeredIn(size: size).center
  //  }
  //
  //  public func centred(in containerSize: CGSize) -> CGRect {
  //    let origin = CGPoint(
  //      x: (containerSize.width - self.width) / 2,
  //      y: (containerSize.height - self.height) / 2
  //    )
  //    return CGRect(origin: origin, size: self.size)
  //  }

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

  // Edges
  public var leadingEdge: CGFloat { minX }
  public var trailingEdge: CGFloat { maxX }
  public var topEdge: CGFloat { minY }
  public var bottomEdge: CGFloat { maxY }

  // Dimensions
  public var horizontal: ClosedRange<CGFloat> { minX...maxX }
  public var vertical: ClosedRange<CGFloat> { minY...maxY }

  // Initialization helpers
  public static func between(point1: CGPoint, point2: CGPoint) -> CGRect {
    let minX = min(point1.x, point2.x)
    let minY = min(point1.y, point2.y)
    let maxX = max(point1.x, point2.x)
    let maxY = max(point1.y, point2.y)

    return CGRect(
      x: minX,
      y: minY,
      width: maxX - minX,
      height: maxY - minY
    )
  }

  // Useful for selection operations
  public func expanded(toInclude rect: CGRect) -> CGRect {
    let newMinX = min(minX, rect.minX)
    let newMinY = min(minY, rect.minY)
    let newMaxX = max(maxX, rect.maxX)
    let newMaxY = max(maxY, rect.maxY)

    return CGRect(
      x: newMinX,
      y: newMinY,
      width: newMaxX - newMinX,
      height: newMaxY - newMinY
    )
  }

  public static func reversible(
    from start: CGPoint,
    to current: CGPoint
  ) -> CGRect {
    let origin = CGPoint(
      x: min(start.x, current.x),
      y: min(start.y, current.y)
    )
    let size = CGSize(
      width: abs(current.x - start.x),
      height: abs(current.y - start.y)
    )
    return CGRect(origin: origin, size: size)
  }

  public static func fromPoints(_ a: CGPoint, _ b: CGPoint) -> CGRect {
    CGRect(
      x: min(a.x, b.x),
      y: min(a.y, b.y),
      width: abs(a.x - b.x),
      height: abs(a.y - b.y)
    )
  }

  /// Useful for a CGRect that needs to be centered within a View
  public init(size: CGSize, centeredIn containerSize: CGSize) {
    let x = (containerSize.width - size.width) / 2
    let y = (containerSize.height - size.height) / 2
    self.init(x: x, y: y, width: size.width, height: size.height)
  }
  
  /// Useful for occasions where origin and size properties
  /// are already defined, just need to be plugged in,
  /// and an extra-quick init is helpful
  public init(_ origin: CGPoint,_ size: CGSize) {
    self.init(origin: origin, size: size)
  }

  public static let example01 = CGRect(
    x: 0,
    y: 0,
    width: 100,
    height: 100
  )

}
