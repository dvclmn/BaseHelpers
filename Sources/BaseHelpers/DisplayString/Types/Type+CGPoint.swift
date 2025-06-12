//
//  Type+CGPoint.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/6/2025.
//

import Foundation

public struct PointDisplayString: ValuePair {
  public typealias FirstValue = CGFloat
  public typealias SecondValue = CGFloat
  public typealias FirstUnit = PointUnit
  public typealias SecondUnit = PointUnit
  
  private let point: CGPoint
  
  public var firstValue: FirstValue { point.x }
  public var secondValue: SecondValue { point.y }
  public var firstUnit: FirstUnit { .x }
  public var secondUnit: SecondUnit { .y }
  
  public init(_ point: CGPoint) {
    self.point = point
  }
  
  public func displayString(decimalPlaces: Int = 2, style: DisplayStringStyle = .short) -> String {
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

// Convenience extension for CGPoint
extension CGPoint {
  public var displayString: PointDisplayString {
    PointDisplayString(self)
  }
}
