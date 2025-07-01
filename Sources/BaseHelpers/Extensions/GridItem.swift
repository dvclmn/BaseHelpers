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
  
  public static func quickAdaptiveColumns(
    min: CGFloat,
    max: CGFloat = .infinity,
    spacing: CGFloat? = nil,
  ) -> Self {
    let result = GridItem(
      .adaptive(minimum: min, maximum: max),
      spacing: spacing
    )
    return [result]
  }
  
//  public static func quickAdaptiveColumns(
//    min: CGFloat = 20,
//    max: CGFloat = 200,
//    spacing: CGFloat? = nil,
//  ) -> GridItem {
//    let result = GridItem(
//      .adaptive(minimum: min, maximum: max),
//      spacing: spacing
//    )
//    return result
//  }
}

//extension GridItem {
//
//}
