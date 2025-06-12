//
//  Type+CGSize.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/6/2025.
//

import Foundation

extension CGSize: ValuePair {
  public typealias FirstValue = CGFloat
  public typealias SecondValue = CGFloat
  public typealias FirstUnit = SizeUnit
  public typealias SecondUnit = SizeUnit
  
  public var firstValue: FirstValue { self.width }
  public var secondValue: SecondValue { self.height }
  public var firstUnit: FirstUnit { .width }
  public var secondUnit: SecondUnit { .height }
  
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

//public var displayString: String {
//  displayString()
//}
//
//public func displayString(
//  decimalPlaces: Int = 2,
//  style: DisplayStringStyle = .short
//) -> String {
//  
//  let width: String = "\(self.width.displayString(decimalPlaces))"
//  let height: String = "\(self.height.displayString(decimalPlaces))"
//  
//  switch style {
//    case .short:
//      return "\(width) x \(height)"
//      
//    case .initials:
//      return "W \(width)  H \(height)"
//      
//    case .full:
//      return "Width \(width)  Height \(height)"
//  }
//}
//
//@available(*, deprecated, message: "This function is deprecated. Use `displayString` instead")
//public var asString: String {
//  "Width: \(width.padLeading(maxDigits: 3, decimalPlaces: 2)) x Height: \(height.padLeading(maxDigits: 3, decimalPlaces: 2))"
//  }
