//
//  Model+DisplayStringConfig.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/7/2025.
//

import Foundation

struct DisplayStringConfig {
  let decimalPlaces: Int
  let integerPlaces: Int
  let grouping: Decimal.FormatStyle.Configuration.Grouping
  let style: ValueDisplayStyle
  let hasSpaceBetweenValues: Bool
  
  init(
    decimalPlaces: Int = 2,
    integerPlaces: Int = 4,
    grouping: Decimal.FormatStyle.Configuration.Grouping = .automatic,
    style: ValueDisplayStyle = .labels,
    hasSpaceBetweenValues: Bool = true
  ) {
    self.decimalPlaces = decimalPlaces
    self.integerPlaces = integerPlaces
    self.grouping = grouping
    self.style = style
    self.hasSpaceBetweenValues = hasSpaceBetweenValues
  }
}

public enum ValueDisplayStyle {
  case labels
  case plain
  
  public var isShowingLabels: Bool { self == .labels }
}
