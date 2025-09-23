//
//  DisplayPairConformance.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 23/9/2025.
//

import BaseHelpers

extension GridPosition: DisplayPair {
  public var valueA: Double { Double(column) }
  public var valueB: Double { Double(row) }
  public var valueALabel: DisplayPairValueLabel { .init("C", "Column") }
  public var valueBLabel: DisplayPairValueLabel { .init("R", "Row") }
}
extension GridDimensions: DisplayPair {
  public var valueA: Double { Double(columns) }
  public var valueB: Double { Double(rows) }
  public var valueALabel: DisplayPairValueLabel { .init("C", "Columns") }
  public var valueBLabel: DisplayPairValueLabel { .init("R", "Rows") }
}
