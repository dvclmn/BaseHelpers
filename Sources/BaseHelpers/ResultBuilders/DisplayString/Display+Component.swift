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
/// DisplayGroup(components: [
///     Component(point.x, label: .x),
///     Component(point.y, label: .y)
///   ]
/// )
/// ```
public typealias Component = DisplayString.Component
extension DisplayString {
  public struct Component {
    let value: any FloatDisplay
    let label: PropertyLabel?

    public init(_ value: any FloatDisplay, label: PropertyLabel? = nil) {
      self.value = value
      self.label = label
    }
  }
}
