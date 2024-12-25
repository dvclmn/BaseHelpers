//
//  Int.swift
//  Helpers
//
//  Created by Dave Coleman on 23/8/2024.
//

import Foundation

public extension Int {
  /// A Boolean value indicating whether the integer is even.
  var isEven: Bool {
    self % 2 == 0
  }

  var string: String {
    return String(self)
  }
  
  func isWithin(_ collection: some Collection) -> Bool {
    let startIndex = collection.startIndex
    let endIndex = collection.endIndex
    guard let index = collection.index(startIndex, offsetBy: self, limitedBy: endIndex) else {
      return false
    }
    return index < endIndex
  }
  
  
    var numberOfDigits: Int {
      return String(abs(self)).count
    }
  
}

public extension Int64 {
  func getString() -> String {
    return String(self)
  }
}
