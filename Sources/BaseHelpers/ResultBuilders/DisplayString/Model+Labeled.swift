//
//  Model+Labeled.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/10/2025.
//

import Foundation

public struct Labeled {
  public let label: PropertyLabel

//  public let key: String
  public let value: (any StringConvertible)?
  
  /// E.g. for `CGPoint`
  /// ```
  /// Label separator: ": "
  /// Result: X: 10
  public let separator: String
  
  public init(
    _ key: String,
    value: (any StringConvertible)?,
    separator: String = ": "
  ) {
    self.label = PropertyLabel(key)
    self.value = value
    self.separator = separator
  }
  
  public init(
    label: PropertyLabel,
//    propertyLabel: PropertyLabel,
    value: (any StringConvertible)?,
    separator: String = ": "
  ) {
    self.label = label
//    self.key = label.label ?? "??"
    self.value = value
    self.separator = separator
  }
}

// MARK: - StringConvertible Conformance
extension Labeled: StringConvertible {
  public var stringValue: String {
    "\(label)\(separator)\(String(describing: value?.stringValue))"
  }
}
