//
//  Model+Labeled.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/10/2025.
//

import Foundation

/// Aiming to allow this to be either *any* key-value
/// stlye builder element, such as
/// `Labeled("Name", value: model.name)`
///
/// Or also support `FloatDisplay`/`FloatGroup`, like
/// `Labeled()`
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

extension Labeled {
  public func output(
    _ places: DecimalPlaces = .fractionLength(2),
    grouping: Grouping = .automatic
  ) -> String {
    if let float = self.value as? (any FloatDisplay) {
      
//    if value is (any FloatDisplay) {
      return float.displayString(
        places,
        grouping: grouping
      )
    } else {
      return self.stringValue
    }
  }
}

// MARK: - StringConvertible Conformance
extension Labeled: StringConvertible {
  public var stringValue: String {
    "\(label)\(separator)\(String(describing: value?.stringValue))"
  }
}
