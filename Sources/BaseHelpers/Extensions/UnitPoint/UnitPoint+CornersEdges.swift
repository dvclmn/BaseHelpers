//
//  UnitPoint+CornersEdges.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 31/7/2025.
//

import SwiftUI

/// For `UnitPoint` corner cases (e.g. `topLeading`, `bottomTrailing`)
public enum CornerStrategy {
  case include
  case exclude(CornerFallBack)
  
  public var shouldIncludeCorners: Bool {
    switch self {
      case .include: true
      case .exclude: false
    }
  }
}
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
  
  
  public func boundarySize(
    fixedLength: CGFloat,
    opposingDimensionLength: OpposingDimensionLength = .infinite,
    corners: CornerStrategy = .include
    //    includeCorners: Bool = true
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
