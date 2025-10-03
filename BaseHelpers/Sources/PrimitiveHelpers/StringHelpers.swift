//
//  StringHelpers.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/10/2025.
//

import Foundation

extension String {
  public var camelToSnake: String {
    var result = ""
    for (index, ch) in self.enumerated() {
      if ch.isUppercase {
        if index > 0 { result.append("_") }
        result.append(ch.lowercased())
      } else {
        result.append(ch)
      }
    }
    return result
  }
}
