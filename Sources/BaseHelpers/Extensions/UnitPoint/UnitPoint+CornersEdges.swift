//
//  UnitPoint+CornersEdges.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 31/7/2025.
//

import SwiftUI

/// For `UnitPoint` corner cases (e.g. `topLeading`, `bottomTrailing`)
public enum CornerResolutionStrategy {
  case useFixedLength
  case collapse
  case fallback(DimensionLength)

  public func resolvedSize(using fixedLength: CGFloat, in container: CGSize) -> CGSize {
    switch self {
      case .useFixedLength:
        return CGSize(width: fixedLength, height: fixedLength)
      case .collapse:
        return .zero
      case .fallback(let fallbackLength):
        let val = fallbackLength.value ?? 0
        return CGSize(width: val, height: val)
    }
  }
}
//public enum CornerStrategy {
//  case include
//  case exclude(CornerFallBack)
//
//  public var shouldIncludeCorners: Bool {
//    switch self {
//      case .include: true
//      case .exclude: false
//    }
//  }
//}
public enum CornerFallBack {
  case width
  case height
  case zero
  case custom(CGFloat)

  public func value(_ size: CGSize) -> CGFloat {
    switch self {
      case .width: size.width
      case .height: size.height
      case .zero: .zero
      case .custom(let float): float
    }
  }
}
public enum DimensionLength {
  case fixed(CGFloat)
  case fill  // == .infinity
  case collapse  // == .zero
  case auto  // == nil

  var value: CGFloat? {
    switch self {
      case .fixed(let v): return v
      case .fill: return .infinity
      case .collapse: return 0
      case .auto: return nil
    }
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
//public enum OpposingDimensionLength {
//  case infinite
//  case zero
//  case `nil`
//
//  public var value: CGFloat? {
//    switch self {
//      case .infinite: CGFloat.infinity
//      case .zero: CGFloat.zero
//      case .nil: nil
//    }
//  }
//}

extension UnitPoint {

  public func valueFromSize(
    size: CGSize,
    fallBackIfCorner fallBack: CornerFallBack = .zero
  ) -> CGFloat {
    guard let sizeKeyPath else {
      return fallBack.value(size)
    }
    return size[keyPath: sizeKeyPath]
  }
  
  private var sizeKeyPath: KeyPath<CGSize, CGFloat>? {
    if isHorizontalEdge {
      return \.height
    } else if isVerticalEdge {
      return \.width
    } else {
      return nil
    }
  }


  /// The goal:
  ///
  /// To create a Rectangle within a container `CGSize`,
  /// based on a provided `UnitPoint`.
//  public func boundarySize(
//    fixedLength: CGFloat,
//    opposingDimensionLength: OpposingDimensionLength = .infinite,
//    corners: CornerStrategy = .include
//  ) -> FrameDimensions {
//
//    let opposingLength: CGFloat? = opposingDimensionLength.value
//
//    if isHorizontalEdge {
//      return FrameDimensions(
//        width: opposingLength,
//        height: fixedLength
//      )
//
//    } else if isVerticalEdge {
//      return FrameDimensions(
//        width: fixedLength,
//        height: opposingLength
//      )
//
//    } else if isCorner {
//      return corners.shouldIncludeCorners
//        ? FrameDimensions(
//          width: fixedLength,
//          height: fixedLength
//        )
//        : FrameDimensions(
//          width: .zero,
//          height: .zero
//        )
//    } else {
//      return FrameDimensions(
//        width: .zero,
//        height: .zero
//      )
//    }
//  }

}
