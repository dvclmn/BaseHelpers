//
//  Model+DisplayConformances.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/7/2025.
//

import Foundation

extension CGPoint: DisplayStringable {
  public var valueA: Double { x }
  public var valueB: Double { y }
  public var valueALabel: String { "X" }
  public var valueBLabel: String { "Y" }
}
extension CGSize: DisplayStringable {
  public var valueA: Double { width }
  public var valueB: Double { height }
  public var valueALabel: String { "W" }
  public var valueBLabel: String { "H" }
}
extension CGVector: DisplayStringable {
  public var valueA: Double { dx }
  public var valueB: Double { dy }
  public var valueALabel: String { "DX" }
  public var valueBLabel: String { "DY" }
}
extension UnitPoint: DisplayStringable {
  public var valueA: Double { x }
  public var valueB: Double { y }
  public var valueALabel: String { "X" }
  public var valueBLabel: String { "Y" }
}
extension GridPosition: DisplayStringable {
  public var valueA: Double { Double(column) }
  public var valueB: Double { Double(row) }
  public var valueALabel: String { "C" }
  public var valueBLabel: String { "R" }
}
extension GridDimensions: DisplayStringable {
  public var valueA: Double { Double(columns) }
  public var valueB: Double { Double(rows) }
  public var valueALabel: String { "C" }
  public var valueBLabel: String { "R" }
}
