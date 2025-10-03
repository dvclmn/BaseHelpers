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

// MARK: - String, Ranges, Regex
extension Range<String.Index>: StringConvertible {
  public var stringValue: String { self.description }
}

extension Substring: StringConvertible {
  public var stringValue: String { String(self) }
}

extension AnyRegexOutput: StringConvertible {
  public var stringValue: String {
    StringGroup {
      self.summarise(key: \.name)
      
    }
    
  }
}


