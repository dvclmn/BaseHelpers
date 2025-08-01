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

public enum RectBoundaryPlacement {
  case inside
  case centre
  case outside
}

extension UnitPoint {

  public func valueFromSize(
    _ size: CGSize,
    fallBackIfCorner fallBack: CornerFallBack = .zero
  ) -> CGFloat {
    guard let sizeKeyPath else {
      return fallBack.value(size)
    }
    return size[keyPath: sizeKeyPath]
  }

  public func valueFromViewDimensions(
    dimensions: ViewDimensions
  ) -> CGFloat? {
    guard let viewDimensionsKeyPath else {
      return nil
    }
    return dimensions[keyPath: viewDimensionsKeyPath]
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

  private var viewDimensionsKeyPath: KeyPath<ViewDimensions, CGFloat>? {
    if isHorizontalEdge {
      return \.height
    } else if isVerticalEdge {
      return \.width
    } else {
      return nil
    }
  }
}

public enum CornerFallBack {
  case width
  case height
  //  case detect(UnitPoint)
  case zero
  case custom(CGFloat)

  public func value(_ size: CGSize) -> CGFloat {
    switch self {
      case .width: size.width
      case .height: size.height
      //      case .detect(let unitPoint): size[keyPath: unitPoint.si]
      case .zero: .zero
      case .custom(let float): float
    }
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
