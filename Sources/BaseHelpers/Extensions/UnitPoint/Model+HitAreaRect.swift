//
//  Model+HitAreaRect.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/8/2025.
//

import SwiftUI

/// An Adaptation
public struct HitAreaLayout {
  public let anchor: UnitPoint
  //  public let fillDirection: Axis
  public let thickness: CGFloat
  public let corners: HitAreaCorner
  //  public let excludingCorners: Bool

  public var fillDirection: Axis {
    anchor.toAxis ?? .vertical
  }

  public init(
    anchor: UnitPoint,
    //    fill: Axis,
    thickness: CGFloat,
    corners: HitAreaCorner
  ) {
    self.anchor = anchor
    //    self.fillDirection = fill
    self.thickness = thickness
    self.corners = corners
  }

  public init(
    from unitPoint: UnitPoint,
    thickness: CGFloat,
    corners: HitAreaCorner,
  ) {
    if unitPoint.isEdge {
      self = HitAreaLayout.edge(
        unitPoint,
        thickness: thickness,
        corners: corners
      )

    } else {
      self = HitAreaLayout.corner(
        unitPoint,
        thickness: thickness,
        corners: corners
          //        size: thickness
      )

    }
  }
}

extension HitAreaLayout {

  public static func edge(
    _ edge: UnitPoint,
    thickness: CGFloat,
    corners: HitAreaCorner
  ) -> HitAreaLayout {
    return HitAreaLayout(
      anchor: edge,
      thickness: thickness,
      corners: corners
    )
  }

  public static func corner(
    _ corner: UnitPoint,
    thickness: CGFloat,
    corners: HitAreaCorner,
    //    size: CGFloat
  ) -> HitAreaLayout {

    HitAreaLayout(
      anchor: corner,
      thickness: thickness,
      corners: corners
        //      excludingCorners: false
    )
  }

  public var alignment: Alignment {
    anchor.toAlignment
  }

  public var fillSize: CGSize {
    switch anchor.pointType {
      case .horizontalEdge:
        return CGSize(width: .infinity, height: thickness)
      case .verticalEdge:
        return CGSize(width: thickness, height: .infinity)
      case .corner:
        return corners.value(thickness)
      case .centre:
        return .zero

    }
  }

  public var edgePadding: EdgeInsets {
    guard !corners.shouldIncludeCorners else { return .zero }
    let inset = thickness
    switch anchor {
      case .top:
        return EdgeInsets(leading: inset, trailing: inset)
      case .bottom:
        return EdgeInsets(leading: inset, trailing: inset)
      case .leading:
        return EdgeInsets(top: inset, bottom: inset)
      case .trailing:
        return EdgeInsets(top: inset, bottom: inset)
      default:
        return .zero
    }
  }
}
extension EdgeInsets {
  static var zero: EdgeInsets {
    EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
  }

  init(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) {
    self.init()
    self.top = top
    self.leading = leading
    self.bottom = bottom
    self.trailing = trailing
  }
}

public enum HitAreaCorner {
  case zero  // No corner needed
  case thickness
  case fixedSize(CGSize)

  public func value(_ thickness: CGFloat) -> CGSize {
    switch self {
      case .zero: .zero
      case .thickness: CGSize(fromLength: thickness)
      case .fixedSize(let size): size
    }
  }

  public var shouldIncludeCorners: Bool {
    switch self {
      case .zero: false
      default: true
    }
  }
}

/// The edge we’re describing: e.g. `.top`, `.trailing`
/// The full canvas size (so we know how wide/tall things are)
/// How 'thick' the hit area should be (e.g. 20 points)
/// Whether to leave room for corner hit areas
/// If so, how big the corners are (to subtract from edge length)
//  public static func fromEdge(
//    _ edge: UnitPoint,
//    container: CGSize,
//    thickness: CGFloat,
//    excludingCorners: Bool = true,
//    cornerSize: CGFloat? = nil  // now optional
//  ) -> HitAreaRect {
//    let inferredCornerSize = cornerSize ?? thickness
//
//    let width: CGFloat
//    let height: CGFloat
//
//    switch edge {
//      case .top, .bottom:
//        /// Full width edge (minus corners if needed)
//        width = container.width - (excludingCorners ? 2 * inferredCornerSize : 0)
//        height = thickness
//
//      case .leading, .trailing:
//        /// Full height edge (minus corners if needed)
//        width = thickness
//        height = container.height - (excludingCorners ? 2 * inferredCornerSize : 0)
//
//      default:
//        /// Non-edge point? Return zero-sized rect
//        return HitAreaRect(anchor: edge, size: .zero, alignment: edge.toAlignment)
//    }
//
//    let hitAreaSize =  CGSize(
//      width: max(0, width),
//      height: max(0, height)
//    )
//
//    return HitAreaRect(
//      anchor: edge,
//      size: hitAreaSize,
//      alignment: edge.toAlignment
//    )
//  }
//
//  public static func fromCorner(
//    _ corner: UnitPoint,
//    thickness: CGFloat
//  ) -> HitAreaRect {
//    let size = CGSize(width: thickness, height: thickness)
//    return HitAreaRect(anchor: corner, size: size, alignment: corner.toAlignment)
//  }
//}

//public struct UnitRect {
//  public let anchor: UnitPoint
//  public let width: DimensionLength
//  public let height: DimensionLength
//  public let cornerStrategy: CornerResolutionStrategy
//
//  public init(
//    anchor: UnitPoint,
//    width: DimensionLength,
//    height: DimensionLength,
//    cornerStrategy: CornerResolutionStrategy = .useFixedLength
//  ) {
//    self.anchor = anchor
//    self.width = width
//    self.height = height
//    self.cornerStrategy = cornerStrategy
//  }
//
//  public func resolvedSize(in container: CGSize) -> FrameDimensions {
//    if anchor.isCorner {
//      let cornerSize = cornerStrategy.resolvedSize(
//        using: fixedLengthValue,
//        in: container
//      )
//      return FrameDimensions(
//        width: cornerSize.width,
//        height: cornerSize.height
//      )
//    }
//
//    return FrameDimensions(
//      width: resolvedWidth(in: container),
//      height: resolvedHeight(in: container)
//    )
//  }
//
//  // MARK: - Helpers
//
//  private var fixedLengthValue: CGFloat {
//    /// This assumes you're treating either width or height as the "fixed"
//    /// axis when dealing with corner sizing. You can adjust this as needed.
//    width.value ?? height.value ?? 0
//  }
//
//  private func resolvedWidth(in container: CGSize) -> CGFloat? {
//    if anchor.isVerticalEdge {
//      return width.value
//    } else if anchor.isHorizontalEdge {
//      return width.value
//    } else {
//      return width.value  // fallback (non-edge case)
//    }
//  }
//
//  private func resolvedHeight(in container: CGSize) -> CGFloat? {
//    if anchor.isHorizontalEdge {
//      return height.value
//    } else if anchor.isVerticalEdge {
//      return height.value
//    } else {
//      return height.value  // fallback (non-edge case)
//    }
//  }
//
//  public var alignment: Alignment {
//    anchor.toAlignment
//  }
//}
