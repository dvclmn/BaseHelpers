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

//
//@MainActor
//struct CanvasHandler {
//  /// The size of the whole canvas view (e.g. from `.size` in the Canvas)
//  /// This is really nice/handy for stroke hover/selection, as the idea is that
//  /// the user can't resize the window whilst hovering/selecting. So we don't
//  /// need the view size value to be *instant*; debounced is fine.
//  ///
//  /// I've done this in the hopes it reduces at least some of the load from
//  /// these calculations. Although, it could also be argued that if the window
//  /// isn't being resized, then there's no issue of high-volume resize
//  /// calculations anyway...
//  var debouncedViewSize: CGSize = .zero
//
//  /// The fixed, unscaled size of the trackpad (700 x 438)
//  private let trackpadBaseSize: CGSize = TrackpadTouchesView.trackpadSize
//
//}
//
//extension CanvasHandler {
//
//  /// A transform from canvas-space coordinates to trackpad-local space
//  func canvasToTrackpad(
//    _ pointInCanvas: CGPoint,
//    zoom: CGFloat,
//    pan: CGPoint
//  ) -> CGPoint {
//
//    let trackpadOrigin: CGPoint = trackpadOriginInCanvas(zoom: zoom, pan: pan)
//
//    let translated: CGPoint = pointInCanvas - trackpadOrigin
//    let adjustedForZoom: CGPoint = translated.removingZoom(zoom)
//    return adjustedForZoom
//  }
//
//  /// The position (origin) in canvas space where the trackpad should be drawn
//  private func trackpadOriginInCanvas(
//    zoom: CGFloat, pan: CGPoint
//  ) -> CGPoint {
//
//    let adjustedSize: CGSize = debouncedViewSize - zoomedTrackpadSize(zoom)
//    let adjustedSizeHalved: CGSize = adjustedSize / 2
//
//    return CGPoint(
//      x: (adjustedSizeHalved.width) + pan.x,
//      y: (adjustedSizeHalved.height) + pan.y
//    )
//  }
//
//  /// The size of the trackpad after applying zoom
//  func zoomedTrackpadSize(_ zoom: CGFloat) -> CGSize {
//    let result: CGSize = trackpadBaseSize * zoom
//    return result
//  }
//
//}
