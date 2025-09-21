//
//  BFP+Conversions.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 21/9/2025.
//

import Foundation

extension BinaryFloatingPoint {
  public var toDouble: Double {
    return Double(self)
  }
  
  public var toFloat: Float {
    return Float(self)
  }

  public func toPercentString(within range: ClosedRange<Self>) -> String {
    let normalised: Double = Double(self.normalised(from: range))
    let percent = normalised * 100
    return String(percent.displayString(.fractionLength(0)) + "%")
  }

  public var degreesToRadians: Self { self * .pi / 180 }
  public var radiansToDegrees: Self { self * 180 / .pi }

}
