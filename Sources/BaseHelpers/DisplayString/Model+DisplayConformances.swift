//
//  Model+DisplayConformances.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/7/2025.
//

import Foundation

extension Double: SingleValueStringable {
  public var value: Double { self }
}

//extension CGFloat: SingleValueStringable {
//  public var value: CGFloat { self }
//
//  func displayString(
//    _ places: DecimalPlaces<Value>,
//    style: ValueDisplayStyle,
//    hasSpace: Bool,
//    grouping: Decimal.FormatStyle.Configuration.Grouping
//  ) -> String {
//
//  }
//}

extension CGPoint: DisplayPair {
  public var valueA: Double { x }
  public var valueB: Double { y }
  public var valueALabel: String { "X" }
  public var valueBLabel: String { "Y" }

  //  public typealias Value = SingleValueStringable
  //  public var valueALabel: String { "X" }
  //  public var valueBLabel: String { "Y" }
}
//extension CGSize: DisplayPair {
//  public var valueA: Double { width }
//  public var valueB: Double { height }
//  public var valueALabel: String { "W" }
//  public var valueBLabel: String { "H" }
//}
//extension CGVector: DisplayPair {
//  public var valueA: Double { dx }
//  public var valueB: Double { dy }
//  public var valueALabel: String { "DX" }
//  public var valueBLabel: String { "DY" }
//}
//extension UnitPoint: DisplayPair {
//  public var valueA: Double { x }
//  public var valueB: Double { y }
//  public var valueALabel: String { "X" }
//  public var valueBLabel: String { "Y" }
//}
//extension GridPosition: DisplayPair {
//  public var valueA: Double { Double(column) }
//  public var valueB: Double { Double(row) }
//  public var valueALabel: String { "C" }
//  public var valueBLabel: String { "R" }
//}
//extension GridDimensions: DisplayPair {
//  public var valueA: Double { Double(columns) }
//  public var valueB: Double { Double(rows) }
//  public var valueALabel: String { "C" }
//  public var valueBLabel: String { "R" }
//}
