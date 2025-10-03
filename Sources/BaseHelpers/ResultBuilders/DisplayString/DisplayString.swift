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
    return pairs.joined(separator: separator)

    /// Prepares the basic formatting, from `Component`'s
    /// `value: any FloatDisplay`
//    let (values, labels) = components.map { component in
//      let value: String = component.value.displayString(places, grouping: grouping)
//      let label: String = labelStyle.labelString(for: component) ?? ""
//      return (value, label)
//    }
//
//    let pairs = zip(labels, values).map { "\($0) \($1)" }
//    return pairs.joined(separator: separator)
    
    /// These labels have been assigned the correct abbreviation style
    /// already, thanks to `DisplayLabelStyle/labelString(for:)`
//    let labelStrings = components
//    
//    
//    labelStyle.labelString(for: component) ?? ""
//    let value = component.value.displayString(places, grouping: grouping)
//
//    let pairs = zip(labelStrings, formattedValues).map { "\($0) \($1)" }
//    return pairs.joined(separator: separator)

  }
}

extension String {
  public static let defaultSeparator: String = " × "
}
