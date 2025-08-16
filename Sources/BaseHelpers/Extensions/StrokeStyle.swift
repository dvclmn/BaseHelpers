//
//  StrokeStyle.swift
//  Collection
//
//  Created by Dave Coleman on 16/11/2024.
//

import SwiftUI

extension StrokeStyle {
  public static var simple01: StrokeStyle {
    .init(lineWidth: 1)
  }
  public static var simple02: StrokeStyle {
    .init(lineWidth: 2)
  }
  public static var simple03: StrokeStyle {
    .init(lineWidth: 3)
  }
  public static var simple04: StrokeStyle {
    .init(lineWidth: 4)
  }
  public static func dashed(strokeWidth: CGFloat, gap: CGFloat = 3) -> StrokeStyle {
    StrokeStyle(
      lineWidth: strokeWidth,
      dash: [strokeWidth, strokeWidth * gap],
      dashPhase: strokeWidth
    )
  }
}
