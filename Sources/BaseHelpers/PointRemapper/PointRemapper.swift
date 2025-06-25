//
//  PointRemapper.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 24/6/2025.
//

import Foundation

/// This should just take a *current* `CGSize` (coordinate space),
/// and a target coordinate space. As well as pan and zoom to adjust for.

struct PointRemapper {
  /// Aka origin size
  let currentSize: CGSize
  
  /// This assumes the target is *centred* within the current.
  /// Which may be dumb, but that suits my needs right now
  let targetSize: CGSize
}

extension PointRemapper {
  
  /// A transform from current-space coordinates to target-local space
  func remappedToTarget(
    _ point: CGPoint, // The point in the *current* size
    zoom: CGFloat,
    pan: CGSize
  ) -> CGPoint {
    
    /// This is here as we're not dealing with `CGRect`, which would
    /// give us an origin. We're dealing with `CGSize`, so we need to find the origin.
    let targetOrigin: CGPoint = targetOriginInCurrent(zoom: zoom, pan: pan)
    
    let translated: CGPoint = point - targetOrigin
    let adjustedForZoom: CGPoint = translated.removingZoom(zoom)
    return adjustedForZoom
  }
  
  /// The position (origin) in canvas space where the trackpad should be drawn
  private func targetOriginInCurrent(
    zoom: CGFloat, pan: CGSize
  ) -> CGPoint {
    
    let adjustedSize: CGSize = currentSize - zoomedTargetSize(zoom)
    let adjustedSizeHalved: CGSize = adjustedSize / 2.0
    
    let adjustedWithPan: CGSize = adjustedSizeHalved + pan
    
    let result = CGPoint(fromSize: adjustedWithPan)
    
    return result
  }
  
  /// The size of the target after applying zoom
  private func zoomedTargetSize(_ zoom: CGFloat) -> CGSize {
    let result: CGSize = targetSize * zoom
    return result
  }
  
}
