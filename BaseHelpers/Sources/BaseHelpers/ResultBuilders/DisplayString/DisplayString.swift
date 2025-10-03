//
//  Model+DisplayString.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/10/2025.
//

import Foundation

public struct DisplayString {
  let separator: String
  let components: [Component]

  public init(
    separator: String = .defaultSeparator,
    @DisplayStringBuilder _ components: () -> [Component]
  ) {
    self.components = components()
    self.separator = separator
  }

  public init(
    components: [Component],
    separator: String = .defaultSeparator
  ) {
    self.components = components
    self.separator = separator
  }
}
extension DisplayString {
  public func formatted(
    _ places: DecimalPlaces = .fractionLength(2),
    grouping: Grouping = .automatic,
    labelStyle: DisplayLabelStyle = .standard
  ) -> String {

    let pairs = components.map { component in
      let value = component.value.displayString(places, grouping: grouping)
      let label = labelStyle.labelString(for: component) ?? ""
      return "\(label) \(value)"
    }
    let result = pairs.joined(separator: separator)
    return result
  }
}

extension String {
//  public static let defaultSeparator: String = " x "
  public static let defaultSeparator: String = " × "
}
