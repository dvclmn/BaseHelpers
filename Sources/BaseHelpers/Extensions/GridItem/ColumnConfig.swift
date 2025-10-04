//
//  ColumnsConfig.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/10/2025.
//

import SwiftUI

public struct ColumnConfig: Sendable {
  
  public let mode: Mode
  
  /// Based on `GridItem/spacing`
  /// This is the Horizontal spacing
  /// Note: Will need to make this non-optional, as it's
  /// a pivotal part of `GridContext`'s item frame calculations
  ///
  /// Private because only used by `self.columns`?
  
  public let spacing: CGFloat
  
  /// The per-item alignment
  /// Based on `GridItem/alignment`
  
  public let alignment: Alignment?
  
  public init(
    mode: Mode = .default,
    spacing: CGFloat,
    alignment: Alignment?
  ) {
    self.mode = mode
    self.spacing = spacing
    self.alignment = alignment
  }
}

extension ColumnConfig {
  public var output: [GridItem] {
    self.mode.columns(spacing: spacing, alignment: alignment)
  }
}
