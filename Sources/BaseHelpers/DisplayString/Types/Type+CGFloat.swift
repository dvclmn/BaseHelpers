//
//  Type+CGFloat.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/6/2025.
//
//

import Foundation

extension CGFloat: ValueSingle {
  public typealias FloatType = CGFloat
  public var value: FloatType { self }

  public func displayString(
    decimalPlaces: Int = 2,
    style: DisplayStringStyle = .short
  ) -> String {
    return String(format: "%.\(decimalPlaces)f", self)
  }
}
