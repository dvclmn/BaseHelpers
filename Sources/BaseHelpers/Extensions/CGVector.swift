//
//  CGVector.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 5/5/2025.
//

import Foundation

extension CGVector {
  public static func between(
    _ from: CGPoint,
    _ to: CGPoint,
    dt: TimeInterval
  ) -> CGVector? {
    guard dt > 0 else { return nil }
    return CGVector(
      dx: (to.x - from.x) / dt,
      dy: (to.y - from.y) / dt
    )
  }
}
