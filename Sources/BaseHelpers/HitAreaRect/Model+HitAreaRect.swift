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
  // The edge we’re describing: e.g. `.top`, `.trailing`
  // The full canvas size (so we know how wide/tall things are)
  // How 'thick' the hit area should be (e.g. 20 points)
  // Whether to leave room for corner hit areas
  // If so, how big the corners are (to subtract from edge length)
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
        // Full width edge (minus corners if needed)
        width = container.width - (excludingCorners ? 2 * cornerSize : 0)
        height = thickness
        
      case .leading, .trailing:
        // Full height edge (minus corners if needed)
        width = thickness
        height = container.height - (excludingCorners ? 2 * cornerSize : 0)
        
      default:
        // Non-edge point? Return zero-sized rect
        return HitAreaRect(anchor: edge, size: .zero, alignment: edge.toAlignment)
    }
    
    return HitAreaRect(
      anchor: edge,
      size: CGSize(width: width, height: height),
      alignment: edge.toAlignment
    )
  }
}
