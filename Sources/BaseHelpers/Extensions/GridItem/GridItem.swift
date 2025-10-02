//
//  GridItem.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/10/2025.
//

import SwiftUI

extension Array where Element == GridItem {
  
  /// When the desired number of columns is fixed/known
  public static func columns(
    _ count: Int = 3,
    mode: GridConfig.FitMode = .fill(min: 10, max: .infinity),
    spacing: CGFloat? = nil,
    alignment: Alignment? = nil
  ) -> Self {
    
    let (min, max) = mode.minAndMax
    let result: Self = Array(
      repeating: GridItem(
        .flexible(
          minimum: min,
          maximum: max
        ),
        spacing: spacing,
        alignment: alignment
      ),
      count: count
    )
    return result
  }
  
  /// Adaptive allows not specifying an explicit number of columns.
  /// Instead allowing the column count to change based on availble width
  public static func adaptive(
    mode: GridConfig.FitMode,
    spacing: CGFloat? = nil,
    alignment: Alignment? = nil
  ) -> Self {
    
    let result = GridItem(
      .adaptive(minimum: mode.minAndMax.min, maximum: mode.minAndMax.max),
      spacing: spacing,
      alignment: alignment
    )
    return [result]
  }
}
