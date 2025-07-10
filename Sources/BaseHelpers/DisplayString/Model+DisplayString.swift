//
//  DisplayString.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/7/2025.
//

import SwiftUI

/// This unifies types that have a pair of values
/// that can be formatted for display as a String
public protocol SingleValueStringable {
  associatedtype Value: Numeric
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
/// valueALabel = "X"
/// valueBLabel = "Y"
/// ```
public protocol DisplayPair {
  associatedtype Value: SingleValueStringable
  var valueA: Value { get }
  var valueB: Value { get }
  var valueALabel: String { get }
  var valueBLabel: String { get }
}

//extension CGPoint: DisplayStringable {
//  public var valueA: Double { x }
//  public var valueB: Double { y }
//  public var valueALabel: String { "X" }
//  public var valueBLabel: String { "Y" }
//}
//extension CGSize: DisplayStringable {
//  public var valueA: Double { width }
//  public var valueB: Double { height }
//  public var valueALabel: String { "W" }
//  public var valueBLabel: String { "H" }
//}
//extension CGVector: DisplayStringable {
//  public var valueA: Double { dx }
//  public var valueB: Double { dy }
//  public var valueALabel: String { "DX" }
//  public var valueBLabel: String { "DY" }
//}
//extension UnitPoint: DisplayStringable {
//  public var valueA: Double { x }
//  public var valueB: Double { y }
//  public var valueALabel: String { "X" }
//  public var valueBLabel: String { "Y" }
//}
//extension GridPosition: DisplayStringable {
//  public var valueA: Double { Double(column) }
//  public var valueB: Double { Double(row) }
//  public var valueALabel: String { "C" }
//  public var valueBLabel: String { "R" }
//}
//extension GridDimensions: DisplayStringable {
//  public var valueA: Double { Double(columns) }
//  public var valueB: Double { Double(rows) }
//  public var valueALabel: String { "C" }
//  public var valueBLabel: String { "R" }
//}

/// A lot of types seem to support `formatted()`, but I'm not sure
/// how to spread a wide net and catch all of them. Will list what I do know:
/// `BinaryFloatingPoint`
///
extension SingleValueStringable where Self.Value: BinaryFloatingPoint {
  //extension SingleValueStringable where Self: BinaryFloatingPoint, Self.Value == Double {

  public var displayString: String { self.displayString() }

  /// I like the API of `NumberFormatStyleConfiguration.Precision`,
  /// so I've chosen not to abstract over it, but use it directly, to
  /// express the decimal/integer places.
  public func displayString(
    //  _ decimalPlaces: Int = 2,
    _ places: FloatingPointFormatStyle<Self.Value>.Configuration.Precision = .fractionLength(2),
    //    _ places: NumberFormatStyleConfiguration.Precision = .fractionLength(2),
    style: ValueDisplayStyle = .labels,
    hasSpace: Bool = true,
    grouping: FloatingPointFormatStyle<Self.Value>.Configuration.Grouping = .automatic
  ) -> String {

    //    let formatted = self.formatted(.number.precision(FloatingPointFormatStyle<Double>.Configuration.Precision))
    let valueToFormat = Double(self.value)

    let formatted = valueToFormat.formatted(.number.precision(places).grouping(grouping))

    //    let formatted: FloatingPointFormatStyle<Double>.FormatOutput = self.formatted(.number.precision(places).grouping(grouping))
    return formatted

    //    let formatted: String = self.formatted(
    //      //      .number.precision(
    //      //        .integerAndFractionLength(
    //      //          integer: config.integerPlaces,
    //      //          fraction: config.decimalPlaces
    //      //        )
    //      //      ).grouping(config.grouping)
    //      .number.precision(
    //        .fractionLength(
    //          decimalPlaces
    //        )
    //      ).grouping(grouping)
    //    )
    return formatted

    //    let config = DisplayStringConfig(
    //      decimalPlaces: decimalPlaces,
    //      grouping: grouping,
    //      style: style,
    //      hasSpaceBetweenValues: hasSpace
    //    )

    //    let formatter = SingleValueFormatter(config: config)
    //    let formatter = FloatPairFormatter(pair: self, config: config)
    //    return formatter.displayString
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
