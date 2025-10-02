//
//  StringConvertible.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/10/2025.
//

import Foundation

protocol StringConvertible {
  var stringValue: String { get }
}

extension String: StringConvertible {
  var stringValue: String { self }
}

extension Int: StringConvertible {
  var stringValue: String { String(self) }
}

extension Bool: StringConvertible {
  var stringValue: String { self ? "true" : "false" }
}

extension CGFloat: StringConvertible {
  var stringValue: String { self.displayString }
}

extension Double: StringConvertible {
  var stringValue: String { self.displayString }
}

extension Array: StringConvertible where Element: StringConvertible {
  var stringValue: String {
    self.map(\.stringValue).joined(separator: ", ")
  }
}
