//
//  GridItem.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/6/2025.
//

import SwiftUI

extension Array where Element == GridItem {

  public static func quickColumns(
    _ count: Int = 3,
    spacing: CGFloat? = nil,
  ) -> Self {
    let result: Self = Array(
      repeating: GridItem(.flexible(), spacing: spacing),
      count: count
    )
    return result
  }

  /// Adaptive allows not specifying an explicit number of columns.
  /// Instead allowing the column count to change based on availble width
  public static func quickAdaptive(
    min: CGFloat,
    max: CGFloat = .infinity,
    spacing: CGFloat? = nil,
    alignment: Alignment? = nil
  ) -> Self {
    let result = GridItem(
      .adaptive(minimum: min, maximum: max),
      spacing: spacing,
      alignment: alignment
    )
    return [result]
  }
}
