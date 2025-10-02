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
  /// This is the Horizontal spacing
  /// Note: Will need to make this non-optional, as it's
  /// a pivotal part of `GridContext`'s item frame calculations
  public let spacingItem: CGFloat

  /// Based on `LazyVStack/spacing`
  /// This is the Vertical spacing
  public let spacingGrid: CGFloat?

  /// The per-item alignment
  /// Based on `GridItem/alignment`
  public let alignmentItem: Alignment?

  /// The alignment of the grid within its parent view
  /// Based on `LazyVStack/alignment`
  public let alignmentGrid: HorizontalAlignment

  public init(
    columnMode: ColumnMode = .default,
    spacingItem: CGFloat? = nil,
    spacingGrid: CGFloat? = nil,
    alignmentItem: Alignment? = nil,
    alignmentGrid: HorizontalAlignment = .center
  ) {
    self.columnMode = columnMode
    self.spacingItem = spacingItem ?? 8
    self.spacingGrid = spacingGrid
    self.alignmentItem = alignmentItem
    self.alignmentGrid = alignmentGrid
  }
}

extension GridConfig {

  public var columns: [GridItem] {
    self.columnMode.columns(
      spacing: spacingItem,
      alignment: alignmentItem
    )
  }
}

extension GridConfig: CustomStringConvertible {
  public var description: String {
    return MultiLine {
      "GridConfig"
      columnMode.description
      "Spacing(Item: \(spacingItem.displayString(.fractionLength(0))), Grid: \(spacingGrid?.displayString(.fractionLength(0)) ?? "nil"))"
      "Alignnment(Item: \(alignmentItem?.displayName.standard ?? "nil"), Grid: \(alignmentGrid.displayName))"
    }.output
    
//    """
//    GridConfig [
//      Column mode: \(columnMode)
//      Spacing: Item[\(spacingItem.displayString)], Grid[\(spacingGrid?.displayString ?? "nil")]
//      Alignnment: Item[\(alignmentItem?.displayName.standard ?? "nil")], Grid[\(alignmentGrid.displayName)]
//    ]
//    """
  }
}
