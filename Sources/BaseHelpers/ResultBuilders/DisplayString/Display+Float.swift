//
//  DisplayString.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/7/2025.
//

import SwiftUI

public typealias DecimalPlaces = FloatingPointFormatStyle<Double>.Configuration.Precision
public typealias Grouping = FloatingPointFormatStyle<Double>.Configuration.Grouping

public protocol FloatDisplay {
  associatedtype Value: BinaryFloatingPoint
  var value: Value { get }
  var displayString: String { get }
  
  /// This is an early formatting pass, just to get the
  /// decimal places and other numeric/float based
  /// formatting sorted, before other touches.
  func displayString(
    _ places: DecimalPlaces,
    grouping: Grouping
  ) -> String
}

/// ``StringConvertibleFloat`` doesn't concern itself with
/// properties like `valueLabel`s (e.g. "W" for width etc).
/// Just formatting a single value, and returning it for
/// any further processing required
extension FloatDisplay {

  /// A convenience that just returns the `displayString()`
  /// method with it's default values
  public var displayString: String { self.displayString() }

  /// I like the API of `NumberFormatStyleConfiguration.Precision`,
  /// so I've chosen not to abstract over it, but use it directly, to
  /// express the decimal/integer places.
  ///
  /// Albeit via typeliases ``Grouping``
  /// and ``DecimalPlaces``
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
