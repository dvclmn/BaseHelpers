//
//  DisplayString.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/7/2025.
//

import SwiftUI

public struct FloatConfig {
  let decimalPlaces: Int
  let grouping: Grouping
  
  public init(
    places: Int = 2,
    grouping: Grouping = .automatic
  ) {
    self.decimalPlaces = places
    self.grouping = grouping
  }
}

public protocol FloatDisplay {
  associatedtype Value: BinaryFloatingPoint
  var value: Value { get }
  var config: FloatConfig { get }
  
  var displayString: String { get }

  /// This is an early formatting pass, just to get the
  /// decimal places and other numeric/float based
  /// formatting sorted, before other touches.
  func displayString(
    _ places: Int,
    grouping: Grouping
  ) -> String
}

//public typealias DecimalPlaces = FloatingPointFormatStyle<Double>.Configuration.Precision
public typealias Grouping = FloatingPointFormatStyle<Double>.Configuration.Grouping

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
    _ places: Int = 2,
    grouping: Grouping = .automatic
  ) -> String {

    /// Manually converting from the more ambiguous `BinaryFloatingPoint`,
    /// to `Double`, so the compiler knows exactly what we're dealing with
    let valueToFormat = Double(self.value)

    let formatted = valueToFormat.formatted(
      .number.precision(.fractionLength(places))
        .grouping(grouping)
    )

    return formatted
  }

}
