//
//  DisplayComponent.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/10/2025.
//

import Foundation

// MARK: - Single Component

/// A key-value pair
public struct Component {
  let label: PropertyLabel
  let value: any FloatDisplay

  public init(
    _ label: PropertyLabel,
    value: any FloatDisplay,
  ) {
    self.label = label
    self.value = value
  }
}

extension Component {
  /// Putting the property label separator here,
  /// rather than on the `Component` type itself,
  /// makes it easier to specify the same sep for
  /// multiple Components
  func output(
    propertyLabelSeparator separator: String = ": ",
    labelStyle: PropertyLabel.Style
  ) -> String {
    let labelString = label.stringValue(from: labelStyle) ?? ""
    let valueString = value.displayString(
      value.config.decimalPlaces,
      grouping: value.config.grouping
    )
    return labelString + separator + valueString
  }
}

// MARK: - Component Group
public struct ComponentGroup {
  public let separators: Separators
  public let components: [Component]
  //  let propertyLabelSeparator: String
  //  let componentSeparator: String

  public init(
    separators: Separators = .default,
    //    components: [Component],
    //    labelSep propertyLabelSeparator: String,
    //    componentSep componentSeparator: String,
    _ components: Component...
//    components: () -> [Component]
  ) {
    self.separators = separators
    self.components = components
    //    self.propertyLabelSeparator = propertyLabelSeparator
    //    self.componentSeparator = componentSeparator
  }
}
extension ComponentGroup {

  /// In the moment / case-by-case properties, put into the
  /// function signature, for flexibility
  func output(
    labelStyle: PropertyLabel.Style = .standard
  ) -> String {
    let labels = components.map { component in
      component.output(
        propertyLabelSeparator: separators.propertyLabel,
        labelStyle: labelStyle
      )
    }
    return labels.joined(separators.component)
  }
}

public struct Separators {
  let propertyLabel: String
  let component: String

  public init(
    propertyLabel: String = ": ",
    component: String = " x "
  ) {
    self.propertyLabel = propertyLabel
    self.component = component
  }
}

extension Separators {
  public static var `default`: Separators {
    .init()
  }
  
  public static var cgPoint: Separators {
    .init(propertyLabel: ": ", component: ", ")
  }

  public static var cgSize: Separators {
    .init(propertyLabel: ": ", component: " x ")
  }
}

/// Separators:
/// Between new lines in a builder
/// Between a group of values relating to a type, like 2 values for CGPoint, three for CGRect etc

/// More structured and type safe than previous array -> zip based
/// approach, as shown below.
///
/// Previous:
/// ```
/// var values: [Value] { get }
/// var labels: [DisplayString.PropertyLabel] { get }
/// ```
/// Usage example:
/// ```
/// DisplayString(separator: ", ") {
///   Component("X", value: self.x)
///   Component("Y", value: self.y)
/// }
/// ```
//public typealias Component = DisplayString.Component

//extension DisplayString {
//public struct Component<Value: StringConvertible> {
//  let label: PropertyLabel?
////  let label: PropertyLabel?
//  let value: Value
//  //    let value: any FloatDisplay
//
//  /// E.g. for `CGPoint`
//  /// ```
//  /// Label separator: ": "
//  /// Result: X: 10
//  /// ```
//  let separator: String
//
//  public init(
////    _ label: PropertyLabel?,
//    value: Value,
//    separator: String = .defaultLabelSeparator
//  ) {
////    self.label = label
//    self.value = value
//    self.separator = separator
//  }
//}
//}
