//
//  Pairs.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/10/2025.
//

import Foundation

extension DisplayString {
  public protocol Values {
    associatedtype Value: DisplayString.Float
    var values: [Value] { get }
    var labels: [DisplayString.PropertyLabel] { get }

    /// Default implementation can handle any number of values
    func displayString(
      _ places: DecimalPlaces,
      separator: String,
      style: ValueDisplayStyle,
      grouping: Grouping
    ) -> String
  }

}
extension DisplayString.Values {
  public func displayString(
    _ places: DecimalPlaces = .fractionLength(2),
    separator: String = "x",
    style: ValueDisplayStyle = .plain,
    grouping: Grouping = .automatic
  ) -> String {

    /// This is the counterpart to the older/previous `DisplayPair`
    /// approach, of:
    ///
    /// ```
    /// let valA = valueA.displayString(places, grouping: grouping)
    /// let valB = valueB.displayString(places, grouping: grouping)
    ///
    /// ```
    /// This now maps any number of provided values, so is more flexible
    let formattedValues = values.map { $0.displayString(places, grouping: grouping) }

    switch style {
      case .labels(let labelStyle):
        let labelStrings = labels.map { labelStyle.isFull ? $0.full : $0.abbreviated }
        let pairs = zip(labelStrings, formattedValues).map { "\($0) \($1)" }
        return pairs.joined(separator: separator)

      case .plain:
        return formattedValues.joined(separator: separator)
    }
  }
}
