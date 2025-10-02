//
//  GridItem.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/6/2025.
//

import SwiftUI

extension GridConfig {

  public enum ColumnMode: Sendable {
    public static let `default`: Self = .adaptive(.fill(min: 60, max: 140))

    case fixedColumns(Int, FitMode)
    case adaptive(FitMode)
  }
}

extension GridConfig.ColumnMode {
  public func columns(
    spacing: CGFloat?,
    alignment: Alignment?
  ) -> [GridItem] {
    switch self {
      case .fixedColumns(let count, let mode):
        return [GridItem].columns(
          count,
          mode: mode,
          spacing: spacing,
          alignment: alignment
        )
        
      case .adaptive(let mode):
        return [GridItem].adaptive(
          mode: mode,
          spacing: spacing,
          alignment: alignment
        )
    }
  }
}

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
