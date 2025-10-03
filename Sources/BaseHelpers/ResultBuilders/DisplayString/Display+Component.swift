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
public typealias Component = DisplayString.Component
extension DisplayString {
  public struct Component {
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
  ///     Component(point.x, label: .x),
  ///     Component(point.y, label: .y)
  ///   ]
  /// )
  ///
  /// let rectDisplay = DisplayGroup(components: [
  ///   Component(rect.width, label: .width),
  ///   Component(rect.height, label: .height)
  /// ], separator: " × ")
  /// ```
}
