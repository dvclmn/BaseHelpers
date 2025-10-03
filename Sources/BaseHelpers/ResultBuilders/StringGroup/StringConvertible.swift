//
//  StringConvertible.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/10/2025.
//

import Foundation

public protocol StringConvertible {
  var stringValue: String { get }
}

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

extension Range<String.Index>: StringConvertible {
  public var stringValue: String { self.description }
}

extension Substring: StringConvertible {
  public var stringValue: String { String(self) }
}

extension Labeled: StringConvertible {
  public var stringValue: String {
    "\(key)\(separator)\(value.stringValue)"
  }
}
extension Indented: StringConvertible {
  
  public var stringValue: String {
    content.map { prefix + $0.stringValue }
      .joined(separator: "\n")
  }
}
