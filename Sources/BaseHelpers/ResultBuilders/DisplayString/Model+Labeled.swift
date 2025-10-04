//
//  Model+Labeled.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/10/2025.
//

import Foundation

public struct Labeled {
  public let key: String
  public let value: (any StringConvertible)?
  public let separator: String
  
  public init(
    _ key: String,
    value: (any StringConvertible)?,
    separator: String = ": "
  ) {
    self.key = key
    self.value = value
    self.separator = separator
  }
  
  public init(
    label: PropertyLabel,
//    propertyLabel: PropertyLabel,
    value: (any StringConvertible)?,
    separator: String = ": "
  ) {
    self.key = label.label ?? "??"
    self.value = value
    self.separator = separator
  }
}

// MARK: - StringConvertible Conformance
extension Labeled: StringConvertible {
  public var stringValue: String {
    "\(key)\(separator)\(String(describing: value?.stringValue))"
  }
}
extension Indented: StringConvertible {
  
  public var stringValue: String {
    let indentedItems = content.map { prefix + $0.stringValue }
      .joined(separator: "\n")
    guard let title else {
      return indentedItems
    }
    return title + "\n" + indentedItems
  }
}
