//
//  FloatGroup.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/10/2025.
//

/// Types like `CGPoint` that have floats as it's properties
public protocol FloatGroup {
  var components: [Component] { get }

  /// This is separator of type `component`
  var separator: SeparatorType { get }

  func output() -> String
}

/// Can be a pair (like CGPoint), or three (like CGRect) etc
extension FloatGroup {
  public func output(
    labelStyle: PropertyLabel.Style,
  ) -> String {
    let sepString = separator.stringValue
    let labels = components.map { component in
      let labelSep = component.separator.stringValue
      let labelString = labelStyle.labelString(for: component.label) ?? ""
      let valueString = component.value.stringValue

      return labelString + labelSep + valueString
    }
    return labels.joined(separator.stringValue)
  }
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
