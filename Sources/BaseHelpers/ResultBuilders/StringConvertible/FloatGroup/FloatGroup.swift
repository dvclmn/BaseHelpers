//
//  FloatGroup.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/10/2025.
//

import Foundation

public struct ComponentGroup {
  let components: [Component]
  let propertyLabelSeparator: String
  let componentSeparator: String
  
  public init(
//    components: [Component],
    labelSep propertyLabelSeparator: String,
    componentSep componentSeparator: String,
    components: () -> [Component]
  ) {
    self.components = components()
    self.propertyLabelSeparator = propertyLabelSeparator
    self.componentSeparator = componentSeparator
  }
}
extension ComponentGroup {
  
  /// In the moment / case-by-case properties, put into the
  /// function signature, for flexibility
  func output(
    labelStyle: PropertyLabel.Style = .standard
  ) -> String {
    let labels = components.map {
      $0.output(
        separator: propertyLabelSeparator,
        labelStyle: labelStyle
      )
    }
    return labels.joined(componentSeparator)
  }
}

extension CGPoint {

  /// Baked in / static properties relating to the type, like CGPoint
//  var propertyLabelSeparator: String { ": " }
//  var componentSeparator: String { ", " }
//
//  var components: [Component] {
//    [
//      Component("X", value: self.x),
//      Component("Y", value: self.y),
//    ]
//  }
//
//  /// In the moment / case-by-case properties, put into the
//  /// function signature, for flexibility
//  func displayString(
//    labelStyle: PropertyLabel.Style = .standard
//  ) -> String {
//    let labels = components.map {
//      $0.output(
//        separator: propertyLabelSeparator,
//        labelStyle: labelStyle
//      )
//    }
//    return labels.joined(componentSeparator)
//  }
}

/// Types like `CGPoint` that have floats as it's properties
public protocol FloatGroup {
  var components: ComponentGroup { get }
  var config: FloatConfig { get }
//  var decimalPlaces: Int { get }
//  var grouping: Grouping { get }
//  var components: [Component] { get }
//
//  /// This is separator of type `component`
//  var componentSeparator: String { get }
//
//  /// This allows setting the same consistent
//  /// property separator, no need to do it per-component
//  var propertyLabelSeparator: String? { get }

  //  func output() -> String
}

/// Can be a pair (like CGPoint), or three (like CGRect) etc
extension FloatGroup {
  
  public func displayString(
    
  ) -> String {
    components.output(
      labelStyle: <#T##PropertyLabel.Style#>
    )
  }

  //  public func output(
  //    labelStyle: PropertyLabel.Style,
  //  ) -> String {
  //    let labels = components.map { component in
  //      let labelSep = component.separator.stringValue
  //      let labelString = labelStyle.labelString(for: component.label) ?? ""
  //      let valueString = component.value.stringValue
  //
  //      return labelString + labelSep + valueString
  //    }
  //    return labels.joined(componentSeparator.stringValue)
  //  }

  //  public func buildComponent(
  //    _ label: String,
  //    abbreviation: String? = nil,
  //    valuePath: KeyPath<Self, any StringConvertible>,
  //    //    value: any StringConvertible,
  //    //    labelSeparator: String? = nil
  //  ) -> Component {
  //    let propertyLabel = PropertyLabel(label, abbreviated: abbreviation)
  //    return Component(
  //      propertyLabel,
  //      value: self[keyPath: valuePath],
  //      separator: self.propertyLabelSeparator
  //    )
  //  }
}

//extension CGPoint: FloatGroup {
//
//}

//func formatted(
//  _ places: DecimalPlaces,
//  grouping: Grouping,
//  labelStyle: PropertyLabel.Style
//) -> String {
//
//  if let floatValues = content as? [any FloatDisplay] {
//
//    let labelValuePairs = floatValues.map { component in
//      let labelSep = component
//      let label = labelStyle.labelString(for: component)
//      let value = component.value.displayString(places, grouping: grouping)
//      guard let label else {
//        return value
//      }
//      return label + labelSep + value
//    }
//    let result = labelValuePairs.joined(separator: separator)
//    return result
//
//  } else {
//    return output
//  }
//  }
