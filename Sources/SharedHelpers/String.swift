// The Swift Programming Language
// https://docs.swift.org/swift-book

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

