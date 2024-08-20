//
//  PrettyPrinting.swift
//  Helpers
//
//  Created by Dave Coleman on 20/8/2024.
//

import Foundation

public extension Collection {
  func prettyPrinted<T>(keyPaths: [KeyPath<Element, T>]) -> String {
    var result = "[\n"
    for element in self {
      let values = keyPaths.map { keyPath in
        return "\(element[keyPath: keyPath])"
      }.joined(separator: ", ")
      result += "    \(values),\n"
    }
    result += "]"
    return result
  }
}

public extension Collection where Element == (key: String, value: Int) {
  func prettyPrinted(
    delimiter: String = ".",
    keyFirst: Bool = true,
    stripCharacters: Bool = false
  ) -> String {
    var result = "Headers:\n\n"
    for element in self {
      let key = stripCharacters ? element.key.filter { !$0.isWhitespace && $0.isLetter } : element.key
      let value = element.value
      if keyFirst {
        result += "\(value)\(delimiter) \"\(key)\"\n"
      } else {
        result += "\"\(key)\"\(delimiter) \(value)\n"
      }
    }
    return result
  }
}
