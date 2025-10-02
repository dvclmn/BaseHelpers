//
//  Model+DisplayPair.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/7/2025.
//

import Foundation

/// A good example is `CGPoint`:
/// ```
/// valueA = self.x // The actual x float value
/// valueB = self.y
/// valueALabel = "X" // The property's label: This is the "X" value
/// valueBLabel = "Y"
/// ```
public protocol DisplayPair {
  associatedtype Value: StringConvertibleFloat
  var valueA: Value { get }
  var valueB: Value { get }
  var valueALabel: DisplayPairValueLabel { get }
  var valueBLabel: DisplayPairValueLabel { get }

  var displayString: String { get }
  var displayStringStyled: AttributedString { get }

  /// This is the value pair counterpart to
  /// `StringConvertibleFloat` method of the same name.
  func displayString(
    _ places: DecimalPlaces,
    separator: String,
    style: ValueDisplayStyle,
    grouping: Grouping
  ) -> String

  func displayStringStyled(
    _ places: DecimalPlaces,
    separator: String,
    style: ValueDisplayStyle,
    grouping: Grouping
  ) -> AttributedString
}

public struct DisplayPairValueLabel {
  let abbreviated: String
  let full: String

  public init(abbreviated: String, full: String) {
    self.abbreviated = abbreviated
    self.full = full
  }

  public init(_ abbreviated: String, _ full: String) {
    self.abbreviated = abbreviated
    self.full = full
  }

  public init(_ abbreviated: String, full: String? = nil) {
    self.abbreviated = abbreviated
    self.full = full ?? abbreviated
  }
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
    separator: String = "x",
    style: ValueDisplayStyle = .plain,
    //    hasSpace: Bool = false,
    grouping: Grouping = .automatic
  ) -> String {

    let valA: String = valueA.displayString(places, grouping: grouping)
    let valB: String = valueB.displayString(places, grouping: grouping)

    let result: String
    switch style {
      case .labels(let style):
        
        /// Note the inclusion of intentional spaces after labels in the below
        switch style {
          case .abbreviated:
            result = "\(valueALabel.abbreviated) \(valA)\(separator)\(valueBLabel.abbreviated) \(valB)"
          case .full:
            result = "\(valueALabel.full) \(valA)\(separator)\(valueBLabel.full) \(valB)"
        }
      case .plain:
        result = "\(valA)\(separator)\(valB)"
    }
    return result
  }

  public func displayStringStyled(
    _ places: DecimalPlaces = .fractionLength(2),
    separator: String = "x",
    style: ValueDisplayStyle = .plain,
    grouping: Grouping = .automatic
  ) -> AttributedString {

    let pair = valuePair(self, places: places, separator: separator)
    return pair
  }

}
