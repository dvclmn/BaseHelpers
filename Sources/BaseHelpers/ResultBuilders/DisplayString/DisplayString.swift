//
//  Model+DisplayString.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/10/2025.
//

import Foundation

public struct DisplayString {
  
  /// A Component is a `label` and `value` pair
  let components: [Component]
  
  /// E.g. for `CGPoint`
  /// ```
  /// Component separator: ", "
  /// Result: X: 10, Y: -20
  /// ```
  let componentSeparator: String
  
  /// E.g. for `CGPoint`
  /// ```
  /// Label separator: ": "
  /// Result: X: 10
  /// ```
  let labelSeparator: String
  
  public init(
    componentSeparator: String = .defaultComponentSeparator,
    labelSeparator: String = .defaultLabelSeparator,
    @DisplayStringBuilder _ components: () -> [Component]
  ) {
    self.components = components()
    self.componentSeparator = componentSeparator
    self.labelSeparator = labelSeparator
//    self.separator = separator
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
extension DisplayString {
  
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
      let label = labelStyle.labelString(for: component)
      let value = component.value.displayString(places, grouping: grouping)
      if let label {
        return "\(label)\(value)"
      }
      return "\(label) \(value)"
    }
    let result = labelValuePairs.joined(separator: separator)
    return result
  }
}

extension String {
  public static let defaultComponentSeparator: String = " × "
  public static let defaultLabelSeparator: String = ": "
}
