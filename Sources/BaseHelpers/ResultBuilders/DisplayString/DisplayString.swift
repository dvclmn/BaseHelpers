//
//  Model+DisplayString.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/10/2025.
//

import Foundation

public struct DisplayString {

  /// A Component is a `label` and `value` pair
  let content: [any StringConvertible]
//  let components: [Component<Value>]

  /// This is the *top-level* seperator, that appears between
  /// each element in the builder (defined on a new line in
  /// the source code). Defaults to and is frequently set to
  /// a new line character `"\n"`
  let separator: SeparatorType

  public init(
    separator: String = SeparatorType.defaultBuilderElement,
    @DisplayStringBuilder _ content: () -> [any StringConvertible]
  ) {
    self.separator = SeparatorType.builderElement(separator)
    self.content = content()
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
  
  /// Trying this out as a default output value
  public var output: String {
    let stringValue = content.map { convertible in
      convertible.stringValue
    }.joined(separator: separator.stringValue)
    
    return stringValue
  }
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
    labelStyle: PropertyLabel.Style
  ) -> String {
    
    if let floatValues = content as? [any FloatDisplay] {
      
      let labelValuePairs = floatValues.map { component in
        let labelSep = component.
        let label = labelStyle.labelString(for: component)
        let value = component.value.displayString(places, grouping: grouping)
        guard let label else {
          return value
        }
        return label + labelSep + value
      }
      let result = labelValuePairs.joined(separator: separator)
      return result
      
    } else {
      return output
    }
  }
}

public enum SeparatorType {
  public static let defaultBuilderElement: String = "\n"
  public static let defaultComponent: String = " × "
  public static let defaultPropertyLabel: String = ": "
  
  /// Seperates elements from a result builder
  /// E.g. often `"\n"`, but can be anything
  case builderElement(String = Self.defaultBuilderElement)
  
  /// Seperates two (or more) `key-value` pairs
  /// E.g. the `" x "` from `800 x 600px`
  /// Or the `", "` from `X: 10, Y: -20`
  case component(String = Self.defaultComponent)
  
  /// Seperates the `key` from the `value`
  /// E.g. the `", "` from `X: 10, Y: -20`
  case propertyLabel(String = Self.defaultPropertyLabel)
  
  public var stringValue: String {
    switch self {
      case .builderElement(let string): string
      case .component(let string): string
      case .propertyLabel(let string): string
    }
  }
}
