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
//public struct CoordinateMapper {
//
//  let sourceSize: CGSize
//  let targetSize: CGSize
//
//  public init(
//    sourceSize: CGSize,
//    targetSize: CGSize
//  ) {
//    self.sourceSize = sourceSize
//    self.targetSize = targetSize
//  }
//}
//
//extension CoordinateMapper {
//
//}
