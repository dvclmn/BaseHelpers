//
//  DisplayString.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/7/2025.
//

import SwiftUI

public enum ValueDisplayStyle {
  case labels
  case plain

  public var isShowingLabels: Bool { self == .labels }
}


/// This unifies types that have a pair of values
/// that can be formatted for display as a String
public protocol DisplayStringable {
  associatedtype Value // Constrain?
  var value: Value { get }
  
  /// Value label I think only works in the context
  /// of at least a *pair*, not at the single-value level.
//  var valueLabel: String { get }
  var displayString: String { get }

  /// I should get more clarity on what types I'm targeeting
  /// via the above `associatedtype Value`, to better
  /// constrain the below (e.g. grouping may be meaingless
  /// if not a numeric value).
  func displayString(
    _ decimalPlaces: Int,
    style: ValueDisplayStyle,
    hasSpace: Bool,
    grouping: Decimal.FormatStyle.Configuration.Grouping
  ) -> String
}

/// A good example is `CGPoint`:
/// ```
/// valueA = self.x
/// valueB = self.y
/// valueALabel = "x"
/// valueBLabel = "y"
/// ```
public protocol DisplayPair {
  associatedtype Value: DisplayStringable
  var valueA: Value { get }
  var valueB: Value { get }
  var valueALabel: String { get }
  var valueBLabel: String { get }
}

extension BinaryFloatingPoint: DisplayStringable {
  public var value: Self { self }
}


extension CGPoint: DisplayStringable {
  public var valueA: Double { x }
  public var valueB: Double { y }
  public var valueALabel: String { "X" }
  public var valueBLabel: String { "Y" }
}
extension CGSize: DisplayStringable {
  public var valueA: Double { width }
  public var valueB: Double { height }
  public var valueALabel: String { "W" }
  public var valueBLabel: String { "H" }
}
extension CGVector: DisplayStringable {
  public var valueA: Double { dx }
  public var valueB: Double { dy }
  public var valueALabel: String { "DX" }
  public var valueBLabel: String { "DY" }
}
extension UnitPoint: DisplayStringable {
  public var valueA: Double { x }
  public var valueB: Double { y }
  public var valueALabel: String { "X" }
  public var valueBLabel: String { "Y" }
}
extension GridPosition: DisplayStringable {
  public var valueA: Double { Double(column) }
  public var valueB: Double { Double(row) }
  public var valueALabel: String { "C" }
  public var valueBLabel: String { "R" }
}
extension GridDimensions: DisplayStringable {
  public var valueA: Double { Double(columns) }
  public var valueB: Double { Double(rows) }
  public var valueALabel: String { "C" }
  public var valueBLabel: String { "R" }
}

extension DisplayStringable {

  public var displayString: String { self.displayString() }

  public func displayString(
    _ decimalPlaces: Int = 2,
    style: ValueDisplayStyle = .labels,
    hasSpace: Bool = true,
    grouping: Decimal.FormatStyle.Configuration.Grouping = .automatic
  ) -> String {

    let config = DisplayStringConfig(
      decimalPlaces: decimalPlaces,
      grouping: grouping,
      style: style,
      hasSpaceBetweenValues: hasSpace
    )
    let formatter = FloatPairFormatter(pair: self, config: config)
    return formatter.displayString
  }
}

extension BinaryFloatingPoint {
  public var displayString: String {
    return displayString()
  }

  public func displayString(
    _ decimalPlaces: Int = 2,
    grouping: Decimal.FormatStyle.Configuration.Grouping = .automatic
  ) -> String {

    let formatter = SingleValueFormatter(
      config: .init(
        decimalPlaces: decimalPlaces,
        grouping: grouping,
        style: .plain,
        hasSpaceBetweenValues: false
      )
    )
    return formatter.displayString(Double(self), valueLabel: "")

  }
}
extension CGRect {
  public func displayString(
    _ decimalPlaces: Int = 2,
    grouping: Decimal.FormatStyle.Configuration.Grouping = .automatic
  ) -> String {

    let formattedOrigin = self.origin.displayString(decimalPlaces, grouping: grouping)
    let formattedSize = self.size.displayString(decimalPlaces, grouping: grouping)

    return String("Origin: \(formattedOrigin), Size: \(formattedSize)")
  }
}

struct DisplayStringConfig {
  let decimalPlaces: Int
  let integerPlaces: Int
  let grouping: Decimal.FormatStyle.Configuration.Grouping
  let style: ValueDisplayStyle
  let hasSpaceBetweenValues: Bool

  init(
    decimalPlaces: Int = 2,
    integerPlaces: Int = 4,
    grouping: Decimal.FormatStyle.Configuration.Grouping = .automatic,
    style: ValueDisplayStyle = .labels,
    hasSpaceBetweenValues: Bool = true
  ) {
    self.decimalPlaces = decimalPlaces
    self.integerPlaces = integerPlaces
    self.grouping = grouping
    self.style = style
    self.hasSpaceBetweenValues = hasSpaceBetweenValues
  }
}

struct FloatPairFormatter {
  let pair: any FloatPair
  let config: DisplayStringConfig

  init(
    pair: any FloatPair,
    config: DisplayStringConfig
  ) {
    self.pair = pair
    self.config = config
  }
}

extension FloatPairFormatter {
  var displayString: String {

    let formatter = SingleValueFormatter(config: config)

    let formattedA: String = formatter.displayString(pair.valueA, valueLabel: pair.valueALabel)
    let formattedB: String = formatter.displayString(pair.valueB, valueLabel: pair.valueBLabel)

    let spaceIfNeeded: String = config.hasSpaceBetweenValues ? " " : ""

    let formattedResult = String("\(formattedA),\(spaceIfNeeded)\(formattedB)")
    return formattedResult
  }
}

struct SingleValueFormatter {
  let config: DisplayStringConfig

  init(
    config: DisplayStringConfig
  ) {
    self.config = config
  }

  func displayString(_ value: Double, valueLabel: String) -> String {

    let formatted: String = value.formatted(
      //      .number.precision(
      //        .integerAndFractionLength(
      //          integer: config.integerPlaces,
      //          fraction: config.decimalPlaces
      //        )
      //      ).grouping(config.grouping)
      .number.precision(
        .fractionLength(
          config.decimalPlaces
        )
      ).grouping(config.grouping)
    )
    return formatted

  }

}
