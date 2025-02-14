//
//  EasingFunctions.swift
//  Collection
//
//  Created by Dave Coleman on 15/11/2024.
//

import Foundation

public enum ScalingCurve {
  case linear
  case quadratic
  case cubic
  case exponential
  case custom((Double) -> Double)

  public func applyCurve(_ value: CGFloat) -> CGFloat {
    switch self {
      case .linear:
        return value

      case .quadratic:
        /// Starts slow, ends fast
        return pow(value, 2)

      case .cubic:
        /// Even more dramatic curve
        return pow(value, 3)

      case .exponential:
        // Quick start, gradual end
        return 1 - exp(-value * 3)

      case .custom(let function):
        return CGFloat(function(Double(value)))
    }
  }

  //  static let exampleCustomCurve = DynamicScaleEffect(
  //    curve: .custom { value in
  //      // Sigmoid function for S-shaped curve
  //      1 / (1 + exp(-10 * (value - 0.5)))
  //    }
  //  )
}
