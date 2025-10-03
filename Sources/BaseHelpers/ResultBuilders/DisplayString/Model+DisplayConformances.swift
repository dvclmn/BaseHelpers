//
//  Model+DisplayConformances.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/7/2025.
//

import SwiftUI

/// Notes on balance between flexibility and semantic / pre-defined
/// display strings. E.g. allowing any arbitrary number of
/// `values: [DisplayString.Float]` and
/// `labels: [DisplayString.PropertyLabel]`
/// (which has no semantic meaning at all, or guidelines)
/// v.s. strongly typed protocols that allow per-type logical
/// semantic encodings. Such as `PointDisplayable`,
/// which would enforce something like the below:
/// ```
/// // This is right
/// // X: 20, y: -10
///
/// // This is also right
/// // X 20 Y -10
///
/// // This doesn't make sense
/// // X: 20 x Y: -10
///
/// ```

/// Primitive conformances
extension Double: FloatDisplay {
  public var value: Self { self }
}
extension CGFloat: FloatDisplay {
  public var value: Self { self }
}

// Keep FloatDisplay for common cases
extension CGPoint: FloatDisplay {
  public var values: [CGFloat] { [x, y] }
  public var labels: [DisplayString.PropertyLabel] { [.x, .y] }
}

// But also support more values
extension CGRect: FloatDisplay {
  public var values: [CGFloat] { [origin.x, origin.y, size.width, size.height] }
  public var labels: [DisplayString.PropertyLabel] { [.x, .y, .width, .height] }
}

extension CGPoint: FloatDisplay {
  public var valueA: Double { x }
  public var valueB: Double { y }
  public var labelA: PropertyLabel { .init("X") }
  public var labelB: PropertyLabel { .init("Y") }
}

extension CGSize: FloatDisplay {
  public var valueA: Double { width }
  public var valueB: Double { height }
  public var labelA: PropertyLabel { .init("W", "Width") }
  public var labelB: PropertyLabel { .init("H", "Height") }
}
extension CGVector: FloatDisplay {
  public var valueA: Double { dx }
  public var valueB: Double { dy }
  public var labelA: PropertyLabel { .init("DX") }
  public var labelB: PropertyLabel { .init("DY") }

}
extension UnitPoint: FloatDisplay {
  public var valueA: Double { x }
  public var valueB: Double { y }
  public var labelA: PropertyLabel { .init("X") }
  public var labelB: PropertyLabel { .init("Y") }
}
extension UnitPoint: FloatDisplay {
  public var valueA: Double { x }
  public var valueB: Double { y }
  public var labelA: PropertyLabel { .init("X") }
  public var labelB: PropertyLabel { .init("Y") }
}
