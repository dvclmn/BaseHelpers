//
//  GridItem.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/6/2025.
//

import SwiftUI

extension Array where Element == GridItem {

  /// When the desired number of columns is fixed/known
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
    mode: GridFitMode,
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

public enum GridFitMode: RawRepresentable, ModelBase {
  case fill(min: CGFloat, max: CGFloat = .infinity)
  case fixedWidth(width: CGFloat)
  
  public init?(rawValue: String) {
    switch rawValue {
      case "Fill": self = .fill(min: 100)
      case "Fixed": self = .fixedWidth(width: 0)
      default: return nil
    }
  }
  
  public var rawValue: String {
    switch self {
      case .fill: "Fill"
      case .fixedWidth: "Fixed"
    }
  }
  
  public var minAndMax: (min: CGFloat, max: CGFloat) {
    switch self {
      case .fill(min: let min, max: let max):
        return (min, max)
      case .fixedWidth(width: let width):
        return (width, width)
    }
  }
}
