//
//  Conformance+Ranges.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/10/2025.
//

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
      self.summarise(key: \.range)
      self.summarise(key: \.type)
      self.summarise(key: \.value)
    }
    .output
  }
}
