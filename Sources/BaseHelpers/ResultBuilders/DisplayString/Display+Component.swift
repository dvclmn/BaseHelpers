//
//  DisplayComponent.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/10/2025.
//

import Foundation

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
public typealias Component = DisplayString.Component

extension DisplayString {
  public struct Component {
    let label: PropertyLabel?
    let value: any FloatDisplay

    public init(
      _ label: PropertyLabel?,
      value: any FloatDisplay,
    ) {
      self.label = label
      self.value = value
    }
  }
}
