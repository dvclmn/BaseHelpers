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

/// I think I can just express the other shapes, directly.
/// E.g. single float values like `CGFloat` using `BinaryFloatingPoint`,
/// `CGRect`, who has four values to display, etc.
public protocol ValuePair {
  var valueA: Double { get }
  var valueB: Double { get }

  var valueALabel: String { get }
  var valueBLabel: String { get }

  var displayString: String { get }
  func displayString(
    _ decimalPlaces: Int,
    style: ValueDisplayStyle,
    hasSpace: Bool,
    grouping: Decimal.FormatStyle.Configuration.Grouping
  ) -> String
}

extension CGPoint: ValuePair {
  public var valueA: Double { x }
  public var valueB: Double { y }
  public var valueALabel: String { "X" }
  public var valueBLabel: String { "Y" }
}
extension CGSize: ValuePair {
  public var valueA: Double { width }
  public var valueB: Double { height }
  public var valueALabel: String { "W" }
  public var valueBLabel: String { "H" }
}
extension CGVector: ValuePair {
  public var valueA: Double { dx }
  public var valueB: Double { dy }
  public var valueALabel: String { "DX" }
  public var valueBLabel: String { "DY" }
}
extension UnitPoint: ValuePair {
  public var valueA: Double { x }
  public var valueB: Double { y }
  public var valueALabel: String { "X" }
  public var valueBLabel: String { "Y" }
}

extension ValuePair {

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
    let formatter = ValuePairFormatter(pair: self, config: config)
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
  let grouping: Decimal.FormatStyle.Configuration.Grouping
  let style: ValueDisplayStyle
  let hasSpaceBetweenValues: Bool

  init(
    decimalPlaces: Int = 2,
    grouping: Decimal.FormatStyle.Configuration.Grouping = .automatic,
    style: ValueDisplayStyle = .labels,
    hasSpaceBetweenValues: Bool = true
  ) {
    self.decimalPlaces = decimalPlaces
    self.grouping = grouping
    self.style = style
    self.hasSpaceBetweenValues = hasSpaceBetweenValues
  }
}

struct ValuePairFormatter {
  let pair: any ValuePair
  let config: DisplayStringConfig

  init(
    pair: any ValuePair,
    config: DisplayStringConfig
  ) {
    self.pair = pair
    self.config = config
  }
}

extension ValuePairFormatter {
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
      .number.precision(.fractionLength(config.decimalPlaces)).grouping(config.grouping)
    )
    return formatted

  }

}
