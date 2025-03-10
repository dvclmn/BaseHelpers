//
//  Conformances.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 5/3/2025.
//

import Foundation

extension Double: RandomGeneratable {
  public typealias Value = Double
  
  public static func generate(
    count: Int,
    using generator: inout RandomNumberGenerator,
    parameters: RandomisationParameters
  ) -> Double {
    // Just generate a single random value using the provided range
    guard let range = parameters.ranges.first else {
      return 0
    }
    return Double.random(in: range, using: &generator)
  }
}
