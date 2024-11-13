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
}

public extension Int64 {
  func getString() -> String {
    return String(self)
  }
}
