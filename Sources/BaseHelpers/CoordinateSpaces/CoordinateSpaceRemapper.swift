//
//  PointRemapper.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 24/6/2025.
//

import Foundation

/// Maps a point from the original coordinate space into a zoomed and panned,
/// target coordinate space that is centred *within* the original.
///
/// Assumes original and target coordinate spaces both use a top-left origin.
/// The `targetSize` is assumed to be centred in `originalSize`, and zoomed by `zoom`.
public struct CoordinateMapper {

  let originalSize: CGSize
  let targetSize: CGSize

  public init(originalSize: CGSize, targetSize: CGSize) {
    self.originalSize = originalSize
    self.targetSize = targetSize
  }
}

extension CoordinateMapper {

  /// Maps a point from original space to target-local space,
  /// compensating for zoom and pan.
  public func mappedToTarget(
    _ point: CGPoint,  // Point in original space
    zoom: CGFloat,
    pan: CGSize
  ) -> CGPoint {
    let targetOriginInOriginal = self.targetTopLeftInOriginalSpace(zoom: zoom, pan: pan)
    let translated = point - targetOriginInOriginal
    return translated.removingZoom(zoom)
  }

  /// Computes where the top-left corner of the target (after zooming)
  /// should be positioned within the original space,
  /// assuming the target is *centred* and offset by `pan`.
  private func targetTopLeftInOriginalSpace(
    zoom: CGFloat, pan: CGSize
  ) -> CGPoint {

    let zoomedSize = zoomedTargetSize(zoom)

    // How much leftover space remains around the zoomed target?
    let leftover = originalSize - zoomedSize
    let centredOrigin = leftover / 2.0

    let adjusted = centredOrigin + pan

    return CGPoint(fromSize: adjusted)
  }

  private func zoomedTargetSize(_ zoom: CGFloat) -> CGSize {
    targetSize * zoom
  }
}
