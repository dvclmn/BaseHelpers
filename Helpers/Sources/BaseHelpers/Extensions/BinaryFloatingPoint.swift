//
//  BinaryFloatingPoint.swift
//  Helpers
//
//  Created by Dave Coleman on 31/8/2024.
//




public extension BinaryFloatingPoint {
  
  var wholeNumber: String {
    return toDecimalPlace(self, to: 0)
  }
  func toDecimal(_ place: Int) -> String {
    return toDecimalPlace(self, to: place)
  }
  private func toDecimalPlace<T: FloatingPoint>(_ value: T, to decimalPlace: Int) -> String {
    
    guard let value = value as? CVarArg else { return "" }
    let result = String(format: "%.\(decimalPlace)f", value)
    
    return result
  }
  
}


