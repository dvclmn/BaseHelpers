//
//  UnitPoint+CornersEdges.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 31/7/2025.
//

import SwiftUI

/// For `UnitPoint` corner cases (e.g. `topLeading`, `bottomTrailing`)
enum CornerResolutionStrategy {
  case useFixedLength
  case collapse
  case fallback(DimensionLength)
  
  func resolvedSize(using fixedLength: CGFloat, in container: CGSize) -> CGSize {
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
  case fill    // == .infinity
  case collapse // == .zero
  case auto     // == nil
  
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
  let anchor: UnitPoint
  let width: DimensionLength
  let height: DimensionLength
  let cornerStrategy: CornerResolutionStrategy
  
  public func resolvedSize(in container: CGSize) -> FrameDimensions {
    let w = resolvedWidth(in: container)
    let h = resolvedHeight(in: container)
    return FrameDimensions(width: w, height: h)
  }
  
  private func resolvedWidth(in size: CGSize) -> CGFloat? {
    if anchor.isVerticalEdge { return width.value }
    if anchor.isCorner {
      return cornerStrategy.shouldIncludeCorners ? width.value : 0
    }
    return width.value
  }
  
  private func resolvedHeight(in size: CGSize) -> CGFloat? {
    if anchor.isHorizontalEdge { return height.value }
    if anchor.isCorner {
      return cornerStrategy.shouldIncludeCorners ? height.value : 0
    }
    return height.value
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
  
  /// The goal:
  ///
  /// To create a Rectangle within a container `CGSize`,
  /// based on a provided `UnitPoint`.
  public func boundarySize(
    fixedLength: CGFloat,
    opposingDimensionLength: OpposingDimensionLength = .infinite,
    corners: CornerStrategy = .include
  ) -> FrameDimensions {
    
    let opposingLength: CGFloat? = opposingDimensionLength.value
    
    if isHorizontalEdge {
      return FrameDimensions(
        width: opposingLength,
        height: fixedLength
      )
      
    } else if isVerticalEdge {
      return FrameDimensions(
        width: fixedLength,
        height: opposingLength
      )
      
    } else if isCorner {
      return corners.shouldIncludeCorners
      ? FrameDimensions(
        width: fixedLength,
        height: fixedLength
      )
      : FrameDimensions(
        width: .zero,
        height: .zero
      )
    } else {
      return FrameDimensions(
        width: .zero,
        height: .zero
      )
    }
  }

}
