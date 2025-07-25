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
  var valueALabel: DisplayPairLabel { get }
  var valueBLabel: DisplayPairLabel { get }

  var displayString: String { get }
  var displayStringStyled: AttributedString { get }

  func displayString(
    places: DecimalPlaces,
    separator: String, // Add spaces as needed here
    style: ValueDisplayStyle,
//    hasSpace: Bool,
    grouping: Grouping
  ) -> String

  func displayStringStyled(
    places: DecimalPlaces,
    separator: String,
    style: ValueDisplayStyle,
//    hasSpace: Bool,
    grouping: Grouping
  ) -> AttributedString
}

public struct DisplayPairLabel {
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
    places: DecimalPlaces,
    separator: String = "x",
    style: ValueDisplayStyle = .plain,
//    hasSpace: Bool = false,
    grouping: Grouping = .automatic
  ) -> String {

    let valA: String = valueA.displayString(places: places, grouping: grouping)
    let valB: String = valueB.displayString(places: places, grouping: grouping)

    let result: String
    switch style {
      case .labels(let style):
        switch style {
          case .abbreviated:
            result = "\(valueALabel.abbreviated) \(valA)\(separator)\(valueBLabel.abbreviated) \(valB)"
          case .full:
            result = "\(valueALabel.full) \(valA)\(separator)\(valueBLabel.full) \(valB)"
        }
//        result =
//          "\(valueALabel) \(valA)\(separator)\(valueBLabel) \(valB)"

      case .plain:
        result = "\(valA)\(separator)\(valB)"
    }
    return result
  }

  public func displayStringStyled(
    places: DecimalPlaces = .fractionLength(2),
    separator: String = "x",
    style: ValueDisplayStyle = .plain,
//    hasSpace: Bool = false,
    grouping: Grouping = .automatic
  ) -> AttributedString {

    let pair = valuePair(
      self,
      places: places,
      separator: separator,
//      hasSpace: hasSpace
    )
    return pair
  }

}
