//
//  Model+DisplayString.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/10/2025.
//

import Foundation

public struct DisplayString<Value: StringConvertible> {

  /// A Component is a `label` and `value` pair
  let components: [Component<Value>]

  /// E.g. for `CGPoint`
  /// ```
  /// Component separator: ", "
  /// Result: X: 10, Y: -20
  /// ```
  let separator: String

  public init(
    separator: String = .defaultComponentSeparator,
    @DisplayStringBuilder _ components: () -> [Component<Value>]
  ) {
    self.separator = separator
    self.components = components()
  }

  //  public init(
  //    components: [Component],
  //    componentSeparator: String = .defaultComponentSeparator,
  //    labelSeparator: String = .defaultLabelSeparator
  //  ) {
  //    self.components = components
  //    self.componentSeparator = componentSeparator
  //    self.labelSeparator = labelSeparator
  //  }
}
extension DisplayString where Value: FloatDisplay {

  /// This allows customisation at the conformance site,
  /// e.g. for `CGPoint`:
  /// ```
  /// func displayString(
  ///   _ places: DecimalPlaces = .fractionLength(2),
  ///   grouping: Grouping = .automatic,
  ///   labelStyle: DisplayLabelStyle = .standard
  /// ) -> String {
  ///   DisplayString(separator: ", ") {
  ///     Component("X", value: self.x)
  ///     Component("Y", value: self.y)
  ///   }
  ///   .formatted(
  ///     places,
  ///     grouping: grouping,
  ///     labelStyle: labelStyle
  ///   )
  /// }
  /// ```
  func formatted(
    _ places: DecimalPlaces,
    grouping: Grouping,
    labelStyle: DisplayLabelStyle
  ) -> String {
    let labelValuePairs = components.map { component in
      let labelSep = component.separator
      let label = labelStyle.labelString(for: component)
      let value = component.value.displayString(places, grouping: grouping)
      guard let label else {
        return value
      }
      return label + labelSep + value
    }
    let result = labelValuePairs.joined(separator: separator)
    return result
  }
}

extension String {
  public static let defaultComponentSeparator: String = " × "
  public static let defaultLabelSeparator: String = ": "
}
