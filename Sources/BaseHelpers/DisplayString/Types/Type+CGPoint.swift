//
//  Type+CGPoint.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/6/2025.
//

import Foundation

/// ```
/// let point = CGPoint(x: 10.567, y: 20.123)
/// print(point.displayString.displayString(decimalPlaces: 1, style: .short))   // "10.6 x 20.1"
/// print(point.displayString.displayString(decimalPlaces: 2, style: .standard)) // "x10.57 y20.12"
/// print(point.displayString.displayString(decimalPlaces: 2, style: .long))     // "X 10.57  Y 20.12"
/// ```

extension CGPoint: ValuePair {
//public struct PointDisplayString: ValuePair {
  public typealias FirstValue = CGFloat
  public typealias SecondValue = CGFloat
  public typealias FirstUnit = PointUnit
  public typealias SecondUnit = PointUnit
  
//  private let point: CGPoint
  
  public var firstValue: FirstValue { self.x }
  public var secondValue: SecondValue { self.y }
  public var firstUnit: FirstUnit { .x }
  public var secondUnit: SecondUnit { .y }
  
//  public init(_ point: CGPoint) {
//    self.point = point
//  }
  
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
//extension CGPoint {
//  public var displayString: PointDisplayString {
//    PointDisplayString(self)
//  }
//}

//public var displayString: String {
//  self.displayString(style: .full)
//}
//
//public func displayString(decimalPlaces: Int = 2) -> String {
//  return "\(self.x.displayString(decimalPlaces)) x \(self.y.displayString(decimalPlaces))"
//}
//
//public func displayString(decimalPlaces: Int = 2, style: DisplayStringStyle = .short) -> String {
//  
//  let width: String = "\(self.x.displayString(decimalPlaces))"
//  let height: String = "\(self.y.displayString(decimalPlaces))"
//  
//  switch style {
//    case .short:
//      return "\(width) x \(height)"
//      
//    case .full, .initials:
//      return "X \(width)  Y \(height)"
//      
//  }
//}
