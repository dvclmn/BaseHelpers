//
//  UnitPoint+Offset.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/7/2025.
//

import SwiftUI

extension UnitPoint {
  
  /// Example usage:
  ///
  /// ```
  /// let anchor: UnitPoint = .topLeading
  ///
  /// let nudged = anchor.applyOffset(axisOffset: { axis in
  ///   axis == .horizontal ? 8 : 10
  /// }) { dx, dy in
  ///   CGPoint(x: originalPoint.x + dx, y: originalPoint.y + dy)
  /// }
  ///
  /// ```
  /// Applies a directional offset based on the position of the `UnitPoint`.
  /// - Parameters:
  ///   - amount: A closure providing the offset amount for a given axis.
  ///   - apply: A closure that receives the final dx/dy values (you decide how to use them).
  public func applyOffset<T>(
    axisOffset amount: (_ axis: Axis) -> CGFloat,
    apply: (_ dx: CGFloat, _ dy: CGFloat) -> T
  ) -> T {
    let dx = directionalOffset(value: amount(.horizontal), axisValue: x)
    let dy = directionalOffset(value: amount(.vertical), axisValue: y)
    return apply(dx, dy)
  }
  
  /// Simpler version
  ///
  /// ```
  /// let anchor: UnitPoint = .bottomTrailing
  /// let offset = anchor.offset(by: 12)
  /// // offset = CGSize(width: -12, height: -12)
  ///
  /// ```
  public func offset(by amount: CGFloat) -> CGSize {
    let dx = x < 0.5 ? +amount : x > 0.5 ? -amount : 0
    let dy = y < 0.5 ? +amount : y > 0.5 ? -amount : 0
    return CGSize(width: dx, height: dy)
  }
  
  private func directionalOffset(
    value: CGFloat,
    axisValue: CGFloat
  ) -> CGFloat {
    if axisValue < 0.5 {
      return +value  // Left or top → move right/down
    } else if axisValue > 0.5 {
      return -value  // Right or bottom → move left/up
    } else {
      return 0  // Centre → no offset
    }
  }
}
