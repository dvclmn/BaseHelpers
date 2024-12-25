//
//  DecimalPlaces.swift
//  Collection
//
//  Created by Dave Coleman on 19/12/2024.
//

import Foundation


func floatToDecimal<T: BinaryFloatingPoint>(value: T, places: Int) -> String {
  let doubleValue = Double(value)
  let formatted = doubleValue.formatted(.number.precision(.fractionLength(places)))
  return String(formatted)
}


public extension Double {
  
  var toDecimal: String { toDecimal() }
  
  func toDecimal(_ places: Int = 2) -> String {
    floatToDecimal(value: self, places: places)
  }
  
  var toInt: String {
    floatToDecimal(value: self, places: 0)
  }
}

public extension CGFloat {
  var toDecimal: String { toDecimal() }
  
  var toInt: String {
    floatToDecimal(value: self, places: 0)
  }
  
  func toDecimal(_ places: Int = 2) -> String {
    floatToDecimal(value: self, places: places)
  }

}
