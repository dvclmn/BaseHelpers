//
//  Model+DisplayConformances.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/7/2025.
//

import SwiftUI

extension Double: SingleValueStringable {
  public var value: Double { self }
}
extension CGFloat: SingleValueStringable {
  public var value: Double { self.toDouble }
}

extension CGPoint: DisplayPair {
  public var valueA: Double { x }
  public var valueB: Double { y }
  public var valueALabel: DisplayPairLabel { .init("X") }
  public var valueBLabel: DisplayPairLabel { .init("Y") }
}


extension CGSize: DisplayPair {
  public var valueA: Double { width }
  public var valueB: Double { height }
  public var valueALabel: DisplayPairLabel { .init("W", "Width") }
  public var valueBLabel: DisplayPairLabel { .init("H", "Height") }
}
extension CGVector: DisplayPair {
  public var valueA: Double { dx }
  public var valueB: Double { dy }
  public var valueALabel: DisplayPairLabel { .init("DX") }
  public var valueBLabel: DisplayPairLabel { .init("DY") }
//  public var valueALabel: String { "DX" }
//  public var valueBLabel: String { "DY" }
}
extension UnitPoint: DisplayPair {
  public var valueA: Double { x }
  public var valueB: Double { y }
  public var valueALabel: DisplayPairLabel { .init("X") }
  public var valueBLabel: DisplayPairLabel { .init("Y") }
}
extension GridPosition: DisplayPair {
  public var valueA: Double { Double(column) }
  public var valueB: Double { Double(row) }
  public var valueALabel: DisplayPairLabel { .init("C", "Column") }
  public var valueBLabel: DisplayPairLabel { .init("R", "Row") }
}
extension GridDimensions: DisplayPair {
  public var valueA: Double { Double(columns) }
  public var valueB: Double { Double(rows) }
  public var valueALabel: DisplayPairLabel { .init("C", "Columns") }
  public var valueBLabel: DisplayPairLabel { .init("R", "Rows") }
}
