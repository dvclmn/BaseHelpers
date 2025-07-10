//
//  DisplayString.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/7/2025.
//

import SwiftUI

public typealias DecimalPlaces = FloatingPointFormatStyle<Double>.Configuration.Precision
public typealias Grouping = FloatingPointFormatStyle<Double>.Configuration.Grouping

//public typealias DecimalPlaces<Value: BinaryFloatingPoint> = FloatingPointFormatStyle<Value>.Configuration.Precision
//public typealias Grouping<Value: BinaryFloatingPoint> = FloatingPointFormatStyle<Value>.Configuration.Grouping

// MARK: - Single Values
/// This unifies types that have a pair of values
/// that can be formatted for display as a String
public protocol SingleValueStringable {

  /// This can be further constrained via extensions, I guess?
  //  associatedtype Value: BinaryFloatingPoint
  var value: Double { get }
  var displayString: String { get }

  /// I should get more clarity on what types I'm targeeting
  /// via the above `associatedtype Value`, to better
  /// constrain the below (e.g. grouping may be meaingless
  /// if not a numeric value).
  func displayString(
    _ places: DecimalPlaces,
    grouping: Grouping
  ) -> String
}

/// `SingleValueStringable` doesn't concern itself with
/// properties like `valueLabel`s (e.g. "W" for width etc).
/// Just formatting a single value, and returning it for
/// any further processing required
extension SingleValueStringable {

  
  /// A convenience that just returns the `displayString()`
  /// method with it's default values
  public var displayString: String { self.displayString() }

  /// I like the API of `NumberFormatStyleConfiguration.Precision`,
  /// so I've chosen not to abstract over it, but use it directly, to
  /// express the decimal/integer places.
  public func displayString(
    _ places: DecimalPlaces = .fractionLength(2),
    grouping: Grouping = .automatic
  ) -> String {

    /// Manually converting from the more ambiguous `BinaryFloatingPoint`,
    /// to `Double`, so the compiler knows exactly what we're dealing with
    let valueToFormat = Double(self.value)

    let formatted = valueToFormat.formatted(
      .number.precision(places)
        .grouping(grouping)
    )

    return formatted
  }
}

//extension BinaryFloatingPoint {
//
//  public var displayString: String {
//    return displayString()
//  }
//
//  public func displayString(
//    _ decimalPlaces: Int = 2,
//    grouping: Decimal.FormatStyle.Configuration.Grouping = .automatic
//  ) -> String {
//
//    let formatter = SingleValueFormatter(
//      config: .init(
//        decimalPlaces: decimalPlaces,
//        grouping: grouping,
//        style: .plain,
//        hasSpaceBetweenValues: false
//      )
//    )
//    return formatter.displayString(Double(self), valueLabel: "")
//
//  }
//}
//extension CGRect {
//  public func displayString(
//    _ decimalPlaces: Int = 2,
//    grouping: Decimal.FormatStyle.Configuration.Grouping = .automatic
//  ) -> String {
//
//    let formattedOrigin = self.origin.displayString(decimalPlaces, grouping: grouping)
//    let formattedSize = self.size.displayString(decimalPlaces, grouping: grouping)
//
//    return String("Origin: \(formattedOrigin), Size: \(formattedSize)")
//  }
//}
