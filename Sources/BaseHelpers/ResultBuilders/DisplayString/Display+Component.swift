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
public struct DisplayComponent {
  let value: any FloatDisplay
  let label: PropertyLabel?
  //    public let formatOptions: FormatOptions?
  
  public init(_ value: any FloatDisplay, label: PropertyLabel? = nil) {
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
