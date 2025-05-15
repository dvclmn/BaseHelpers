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

extension Double {

  public var displayString: String {
    return self.displayString()
  }

//  public var toDecimal: String { toDecimal() }

//  private func toDecimal(_ places: Int = 2) -> String {
//    floatToDecimal(value: self, places: places)
//  }

  public func displayString(_ places: Int = 2) -> String {
    floatToDecimal(value: self, places: places)
  }
  public var toInt: String {
    floatToDecimal(value: self, places: 0)
  }
}

extension CGFloat {
  
  public var displayString: String {
    return self.displayString()
  }

//  public var toDecimal: String { toDecimal() }

  public var toInt: String {
    floatToDecimal(value: self, places: 0)
  }

  public func displayString(_ places: Int = 2) -> String {
    floatToDecimal(value: self, places: places)
  }
}
