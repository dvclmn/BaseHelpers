//
//  DisplayComponent.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/10/2025.
//

import Foundation

extension DisplayString {

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
  public struct Component<Value: DisplayString.Float> {
    let value: Value
    let label: DisplayString.PropertyLabel?
//    public let formatOptions: FormatOptions?

    public init(_ value: Value, label: DisplayString.PropertyLabel? = nil) {
      self.value = value
      self.label = label
    }
  }
}
