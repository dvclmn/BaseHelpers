//
//  Model+DisplayConformances.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/7/2025.
//

import SwiftUI

/// Primitive conformances
extension Double: FloatDisplay {
  public var value: Self { self }
}
extension CGFloat: FloatDisplay {
  public var value: Self { self }
}

extension CGPoint {
  public func displayString(
    _ places: DecimalPlaces = .fractionLength(2),
    grouping: Grouping = .automatic,
    labelStyle: DisplayLabelStyle = .standard
  ) -> String {
    DisplayString(separator: ", ") {
      Component("X", value: self.x)
      Component("Y", value: self.y)
    }
    .formatted(
      places,
      grouping: grouping,
      labelStyle: labelStyle
    )
  }
}

//// Keep FloatDisplay for common cases
//extension CGPoint: FloatDisplay {
//  public var values: [CGFloat] { [x, y] }
//  public var labels: [DisplayString.PropertyLabel] { [.x, .y] }
//}
//
//// But also support more values
//extension CGRect: FloatDisplay {
//  public var values: [CGFloat] { [origin.x, origin.y, size.width, size.height] }
//  public var labels: [DisplayString.PropertyLabel] { [.x, .y, .width, .height] }
//}
//
//extension CGPoint: FloatDisplay {
//  public var valueA: Double { x }
//  public var valueB: Double { y }
//  public var labelA: PropertyLabel { .init("X") }
//  public var labelB: PropertyLabel { .init("Y") }
//}
//
//extension CGSize: FloatDisplay {
//  public var valueA: Double { width }
//  public var valueB: Double { height }
//  public var labelA: PropertyLabel { .init("W", "Width") }
//  public var labelB: PropertyLabel { .init("H", "Height") }
//}
//extension CGVector: FloatDisplay {
//  public var valueA: Double { dx }
//  public var valueB: Double { dy }
//  public var labelA: PropertyLabel { .init("DX") }
//  public var labelB: PropertyLabel { .init("DY") }
//
//}
//extension UnitPoint: FloatDisplay {
//  public var valueA: Double { x }
//  public var valueB: Double { y }
//  public var labelA: PropertyLabel { .init("X") }
//  public var labelB: PropertyLabel { .init("Y") }
//}
