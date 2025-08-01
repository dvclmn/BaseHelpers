//
//  Model+HitAreaRect.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/8/2025.
//

import SwiftUI

public struct HitAreaRect {
  public let anchor: UnitPoint
  public let size: CGSize
  public let alignment: Alignment
}

extension HitAreaRect {
  /// The edge we’re describing: e.g. `.top`, `.trailing`
  /// The full canvas size (so we know how wide/tall things are)
  /// How 'thick' the hit area should be (e.g. 20 points)
  /// Whether to leave room for corner hit areas
  /// If so, how big the corners are (to subtract from edge length)
  public static func fromEdge(
    _ edge: UnitPoint,
    container: CGSize,
    thickness: CGFloat,
    excludingCorners: Bool = true,
    cornerSize: CGFloat = 32
  ) -> HitAreaRect {
    
    let width: CGFloat
    let height: CGFloat
    
    switch edge {
      case .top, .bottom:
        /// Full width edge (minus corners if needed)
        width = container.width - (excludingCorners ? 2 * cornerSize : 0)
        height = thickness
        
      case .leading, .trailing:
        /// Full height edge (minus corners if needed)
        width = thickness
        height = container.height - (excludingCorners ? 2 * cornerSize : 0)
        
      default:
        /// Non-edge point? Return zero-sized rect
        return HitAreaRect(anchor: edge, size: .zero, alignment: edge.toAlignment)
    }
    
    return HitAreaRect(
      anchor: edge,
      size: CGSize(width: width, height: height),
      alignment: edge.toAlignment
    )
  }
  
  static func fromCorner(
    _ corner: UnitPoint,
    size: CGFloat
  ) -> HitAreaRect {
  case .topLeading, .topTrailing, .bottomLeading, .bottomTrailing:
    let size = CGSize(width: cornerSize, height: cornerSize)
    return HitAreaRect(anchor: edge, size: size, alignment: edge.toAlignment)
  }
}

public struct UnitRect {
  public let anchor: UnitPoint
  public let width: DimensionLength
  public let height: DimensionLength
  public let cornerStrategy: CornerResolutionStrategy
  
  public init(
    anchor: UnitPoint,
    width: DimensionLength,
    height: DimensionLength,
    cornerStrategy: CornerResolutionStrategy = .useFixedLength
  ) {
    self.anchor = anchor
    self.width = width
    self.height = height
    self.cornerStrategy = cornerStrategy
  }
  
  public func resolvedSize(in container: CGSize) -> FrameDimensions {
    if anchor.isCorner {
      let cornerSize = cornerStrategy.resolvedSize(
        using: fixedLengthValue,
        in: container
      )
      return FrameDimensions(
        width: cornerSize.width,
        height: cornerSize.height
      )
    }
    
    return FrameDimensions(
      width: resolvedWidth(in: container),
      height: resolvedHeight(in: container)
    )
  }
  
  // MARK: - Helpers
  
  private var fixedLengthValue: CGFloat {
    /// This assumes you're treating either width or height as the "fixed"
    /// axis when dealing with corner sizing. You can adjust this as needed.
    width.value ?? height.value ?? 0
  }
  
  private func resolvedWidth(in container: CGSize) -> CGFloat? {
    if anchor.isVerticalEdge {
      return width.value
    } else if anchor.isHorizontalEdge {
      return width.value
    } else {
      return width.value  // fallback (non-edge case)
    }
  }
  
  private func resolvedHeight(in container: CGSize) -> CGFloat? {
    if anchor.isHorizontalEdge {
      return height.value
    } else if anchor.isVerticalEdge {
      return height.value
    } else {
      return height.value  // fallback (non-edge case)
    }
  }
  
  public var alignment: Alignment {
    anchor.toAlignment
  }
}
