//
//  Model+HSVModifier.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 31/8/2025.
//

import Foundation

public protocol HSVModifier {
  var adjustment: HSVAdjustment { get }
}

extension Array where Element == HSVAdjustment {

  /// Combines adjustments with a strength multiplier
  public func combined(with strength: Double) -> HSVAdjustment {
    guard !isEmpty else { return .zero }

    /// Apply strength to each adjustment, then combine them
    let weightedAdjustments = self.map { adjustment in
      HSVAdjustment.zero.interpolated(
        towards: adjustment,
        strength: strength
      )
    }
    return weightedAdjustments.reduce(.zero, +)
  }
}
