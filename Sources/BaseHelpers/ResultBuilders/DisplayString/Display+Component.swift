//
//  DisplayComponent.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/10/2025.
//

import Foundation

//extension DisplayString {

  /// More structured and type safe than previous array -> zip based
  /// approach, as shown below.
  ///
  /// Previous:
  /// ```
  /// var values: [Value] { get }
  /// var labels: [DisplayString.PropertyLabel] { get }
  /// ```
  ///
//}
public struct Component {
  let value: Value
  let label: DisplayString.PropertyLabel?
  //    public let formatOptions: FormatOptions?
  
  public init(_ value: Value, label: DisplayString.PropertyLabel? = nil) {
    self.value = value
    self.label = label
  }
}

/// Usage examples:
/// ```
/// let pointDisplay = DisplayGroup(components: [
///     DisplayComponent(point.x, label: .x),
///     DisplayComponent(point.y, label: .y)
///   ]
/// )
///
/// let rectDisplay = DisplayGroup(components: [
///   DisplayComponent(rect.width, label: .width),
///   DisplayComponent(rect.height, label: .height)
/// ], separator: " × ")
/// ```
