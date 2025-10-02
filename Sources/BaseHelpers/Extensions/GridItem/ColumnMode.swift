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

extension GridConfig.ColumnMode: CustomStringConvertible {
  public var description: String {
    return MultiLine {
      "GridConfig.ColumnMode"
      switch self {
        case .fixedColumns(let count, let fitMode): "\t|\tFixed Columns [count: \(count), mode: \(fitMode)]"
        case .adaptive(let fitMode): "\t|\tAdaptive [mode: \(fitMode)]"
      }
    }.output
  }
}
