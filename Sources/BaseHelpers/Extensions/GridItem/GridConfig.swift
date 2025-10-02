//
//  GridConfig.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/10/2025.
//

import SwiftUI

/// Note: this is specifically geared toward `LazyVGrid`,
/// `LazyHGrid` is not supported.
public struct GridConfig: Sendable {
  
  public let columnMode: ColumnMode
  
  /// Based on `GridItem/spacing`
  public let spacingHorizontal: CGFloat?
  
  /// Based on `LazyVStack/spacing`
  public let spacingVertical: CGFloat?
  
  /// The per-item alignment
  /// Based on `GridItem/alignment`
  public let alignmentItem: Alignment?
  
  /// The alignment of the grid within its parent view
  /// Based on `LazyVStack/alignment`
  public let alignmentGrid: HorizontalAlignment
  
  public init(
    columnMode: ColumnMode = .default,
    spacingHorizontal: CGFloat? = nil,
    spacingVertical: CGFloat? = nil,
    alignmentItem: Alignment? = nil,
    alignmentGrid: HorizontalAlignment = .center
  ) {
    self.columnMode = columnMode
    self.spacingHorizontal = spacingHorizontal
    self.spacingVertical = spacingVertical
    self.alignmentItem = alignmentItem
    self.alignmentGrid = alignmentGrid
  }
}

extension GridConfig {
  public var columns: [GridItem] {
    switch columnMode {
      case .fixedColumns(let count, let mode):
        return [GridItem].columns(
          count,
          mode: mode,
          spacing: spacingHorizontal,
          alignment: alignmentItem
        )
        
      case .adaptive(let mode):
        return [GridItem].adaptive(
          mode: mode,
          spacing: spacingHorizontal,
          alignment: alignmentItem
        )
    }
  }
}
