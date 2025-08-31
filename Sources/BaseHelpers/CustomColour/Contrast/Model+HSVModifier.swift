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
  public func combined(with strength: Double) -> HSVAdjustment {
    let combinedAdjustment: HSVAdjustment = self.reduce(.zero) {
      partialResult,
      adjustment in
      
      partialResult
      + .zero.interpolated(
        towards: adjustment,
        strength: strength
      )
    }
    return combinedAdjustment
  }
}
