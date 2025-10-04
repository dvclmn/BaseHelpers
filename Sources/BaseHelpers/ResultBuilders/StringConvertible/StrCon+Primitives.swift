//
//  ConvertibleConformances.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/10/2025.
//

import Foundation

// MARK: - Primitives
extension String: StringConvertible {
  public var stringValue: String { self }
}

extension Int: StringConvertible {
  public var stringValue: String { String(self) }
}

extension Bool: StringConvertible {
  public var stringValue: String { self ? "true" : "false" }
}

extension CGFloat: StringConvertible {
  public var stringValue: String { self.displayString }
}

extension Double: StringConvertible {
  public var stringValue: String { self.displayString }
}

extension Array: StringConvertible where Element: StringConvertible {
  public var stringValue: String {
    self.map(\.stringValue).joined(separator: ", ")
  }
}
