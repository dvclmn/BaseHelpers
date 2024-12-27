//
//  Int.swift
//  Helpers
//
//  Created by Dave Coleman on 23/8/2024.
//

import Foundation

extension Int {
  /// A Boolean value indicating whether the integer is even.
  public var isEven: Bool {
    self % 2 == 0
  }

  public var string: String {
    String(self)
  }

  public func isWithin(_ collection: some Collection) -> Bool {
    let startIndex = collection.startIndex
    let endIndex = collection.endIndex
    guard let index = collection.index(startIndex, offsetBy: self, limitedBy: endIndex) else {
      return false
    }
    return index < endIndex
  }
  
  public func isWithin(_ range: ClosedRange<Int>, isInclusive: Bool = true) -> Bool {
    if isInclusive {
      return self >= range.lowerBound && self <= (range.upperBound - 1)
    } else {
      return self > range.lowerBound && self < range.upperBound
    }
  }
  
  


  public var numberOfDigits: Int {
    String(abs(self)).count
  }

}

extension Int64 {
  public func getString() -> String {
    String(self)
  }
}
