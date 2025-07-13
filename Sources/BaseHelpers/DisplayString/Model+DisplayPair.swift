//
//  Model+DisplayPair.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/7/2025.
//

import Foundation

/// A good example is `CGPoint`:
/// ```
/// valueA = self.x
/// valueB = self.y
/// valueALabel = "X"
/// valueBLabel = "Y"
/// ```
public protocol DisplayPair {
  associatedtype Value: SingleValueStringable
  var valueA: Value { get }
  var valueB: Value { get }
  var valueALabel: String { get }
  var valueBLabel: String { get }

  var displayString: String { get }
  var displayStringStyled: AttributedString { get }

  func displayString(
    _ places: DecimalPlaces,
    style: ValueDisplayStyle,
    separator: String,
    hasSpace: Bool,
    grouping: Grouping
  ) -> String

  func displayStringStyled(
    _ places: DecimalPlaces,
    style: ValueDisplayStyle,
    separator: String,
    hasSpace: Bool,
    grouping: Grouping
  ) -> AttributedString
}

extension DisplayPair {

  public var displayString: String {
    return displayStringStyled.toString
  }

  public var displayStringStyled: AttributedString {
    let result = valuePair(self)
    return result
  }

  public func displayString(
    _ places: DecimalPlaces,
    style: ValueDisplayStyle,
    separator: String = "x",
    hasSpace: Bool = false,
    grouping: Grouping = .automatic
  ) -> String {

    let valA: String = valueA.displayString(places, grouping: grouping)
    let valB: String = valueB.displayString(places, grouping: grouping)

    let spaceIfNeeded: String = hasSpace ? " " : ""

    let result: String
    switch style {
      case .labels:
        result =
          "\(valueALabel)\(spaceIfNeeded)\(valA)\(spaceIfNeeded)\(separator)\(spaceIfNeeded)\(valueBLabel)\(spaceIfNeeded)\(valB)"

      case .plain:
        result = "\(valA)\(spaceIfNeeded)\(separator)\(spaceIfNeeded)\(valB)"
    }
    return result
  }

  public func displayStringStyled(
    _ places: DecimalPlaces = .fractionLength(2),
    style: ValueDisplayStyle = .labels,
    separator: String = "x",
    hasSpace: Bool = false,
    grouping: Grouping = .automatic
  ) -> AttributedString {

    let pair = valuePair(
      self,
      places: places,
      separator: separator,
      hasSpace: hasSpace
    )
    return pair
  }

}
