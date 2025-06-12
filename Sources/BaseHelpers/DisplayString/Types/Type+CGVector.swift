//
//  Type+CGVector.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/6/2025.
//
//

import Foundation

extension CGVector: ValuePair {
  public typealias FirstValue = CGFloat
  public typealias SecondValue = CGFloat
  
  public var firstValue: FirstValue { self.dx }
  public var secondValue: SecondValue { self.dy }
  
  public func displayString(
    decimalPlaces: Int = 2,
    style: DisplayStringStyle = .short
  ) -> String {
    
    let dxStr: String = "\(self.dx.displayString(decimalPlaces))"
    let dyStr: String = "\(self.dy.displayString(decimalPlaces))"
    
    switch style {
      case .short:
        return "\(dxStr) x \(dyStr)"
        
      case .standard:
        return "DX \(dxStr)  DY \(dyStr)"
        
      case .long:
        return "DX: \(dxStr),  DY: \(dyStr)"
    }
  }
}
