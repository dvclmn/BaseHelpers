//
//  FloatGroupConformances.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/10/2025.
//

import Foundation

extension CGPoint: FloatGroup {

  /// Baked in / static properties relating to the type, like CGPoint
  //  var propertyLabelSeparator: String { ": " }
  //  var componentSeparator: String { ", " }
  //
  public var components: ComponentGroup {
    return ComponentGroup(
      separators: .cgPoint,
      Component("X", value: self.x),
      Component("Y", value: self.y),
    )
  }
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

//extension CGPoint {
//
//  public var floatGroup
//
////extension CGPoint: FloatGroup {
//  public var propertyLabelSeparator: String? { ": " }
//  public var components: [Component] {
//    [
//      Component("X", value: self.x, separator: propertyLabelSeparator),
//    ]
//  }
//}
//
//public struct FloatGroup<Value: FloatGroup> {
//  let components: [Component]
//}
