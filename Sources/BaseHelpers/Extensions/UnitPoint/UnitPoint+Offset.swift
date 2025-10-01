//
//  UnitPoint+Offset.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/7/2025.
//

import SwiftUI

extension UnitPoint {

  /// Returns an offset based on this UnitPoint's position.
  /// Positive `dx`/`dy` will push away from edges, negative will pull inward.
  public func offset(dx: CGFloat, dy: CGFloat) -> CGSize {
    CGSize(
      width: directionMultiplier(for: x) * dx,
      height: directionMultiplier(for: y) * dy
    )
  }
  
  public func offset(by amount: CGFloat) -> CGSize {
    offset(dx: amount, dy: amount)
  }
  public func offset(
    by size: CGSize,
    convention: DimensionToAxisConvention = .widthIsHorizontal
  ) -> CGSize {
    offset(
      dx: convention.horizontalLength(size: size),
      dy: convention.verticalLength(size: size)
    )
  }
  
  private func directionMultiplier(for coordinate: CGFloat) -> CGFloat {
    coordinate < 0.5 ? +1 : coordinate > 0.5 ? -1 : 0
  }
  
}
