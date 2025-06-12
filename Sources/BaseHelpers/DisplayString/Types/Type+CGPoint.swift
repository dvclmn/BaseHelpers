//
//  Type+CGPoint.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/6/2025.
//

import Foundation

extension CGPoint: ValuePair {
  public typealias FirstValue = CGFloat
  public typealias SecondValue = CGFloat

  public var firstValue: FirstValue { self.x }
  public var secondValue: SecondValue { self.y }

  public func displayString(
    decimalPlaces: Int = 2,
    style: DisplayStringStyle = .short
  ) -> String {

    let width: String = "\(self.x.displayString(decimalPlaces))"
    let height: String = "\(self.y.displayString(decimalPlaces))"

    switch style {
      case .short:
        return "\(width) x \(height)"

      case .standard, .long:
        return "X \(width)  Y \(height)"

    }
  }
}
