//
//  CGFloat.swift
//  Collection
//
//  Created by Dave Coleman on 19/12/2024.
//

import Foundation

public extension CGFloat {
  
  var isPositive: Bool {
    self > 0
  }
  
  func padLeading(maxDigits: Int, decimalPlaces: Int? = nil, with padChar: Character = " ") -> String {
    Double(self).padLeading(maxDigits: maxDigits, decimalPlaces: decimalPlaces,  with: padChar)
  }
  
  func normalised(against value: CGFloat, isClamped: Bool = true) -> CGFloat {
    let normalised = self / value
    
    return normalised
  }
  
}
