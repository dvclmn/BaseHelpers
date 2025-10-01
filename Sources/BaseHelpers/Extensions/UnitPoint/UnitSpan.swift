//
//  UnitSpan.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/10/2025.
//

import SwiftUI

/// Pair of two positions in unit space.
/// Describes a start and end point
public struct UnitSpan: Hashable, Sendable {
  var start: UnitPoint
  var end: UnitPoint
  
  public init(start: UnitPoint, end: UnitPoint) {
    self.start = start
    self.end = end
  }
}

extension UnitSpan {
  public var vector: CGVector {
    CGVector(dx: end.x - start.x, dy: end.y - start.y)
  }
}

extension Axis {
  
  /// Returns the start and end UnitPoints for a gradient, given a convention relating dimensions to axis.
  public func toGradientSpan(convention: DimensionToAxisConvention = .widthIsHorizontal) -> UnitSpan {
    switch (self, convention) {
      case (.horizontal, .widthIsHorizontal), (.vertical, .heightIsHorizontal):
        return UnitSpan(start: .leading, end: .trailing)
      case (.horizontal, .heightIsHorizontal), (.vertical, .widthIsHorizontal):
        return UnitSpan(start: .top, end: .bottom)
    }
  }
}
