//
//  Type+CGRect.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/6/2025.
//

import Foundation

extension CGRect: ValuePair {
  public typealias FirstValue = CGPoint
  public typealias SecondValue = CGSize
  public typealias FirstUnit = PointUnit
  public typealias SecondUnit = SizeUnit
  
  public var firstValue: FirstValue { self.origin }
  public var secondValue: SecondValue { self.size }
  public var firstUnit: FirstUnit { . }
  public var secondUnit: SecondUnit { .y }
  
  public func displayString(
    decimalPlaces: Int = 2,
    style: DisplayStringStyle = .short
  ) -> String {
    
    let xStr = String(format: "%.\(decimalPlaces)f", firstValue)
    let yStr = String(format: "%.\(decimalPlaces)f", secondValue)
    
    switch style {
      case .short:
        return "\(xStr) x \(yStr)"
      case .standard:
        return "\(firstUnit.shortForm)\(xStr) \(secondUnit.shortForm)\(yStr)"
      case .long:
        return "\(firstUnit.stringRepresentation) \(xStr)  \(secondUnit.stringRepresentation) \(yStr)"
    }
  }
}
