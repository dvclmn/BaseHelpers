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

  public let columns: ColumnConfig
//  public let columnMode: ColumnConfig.Mode

  /// Based on `LazyVStack/spacing`
  /// This is the Vertical spacing
  public let spacingGrid: CGFloat?

  /// The alignment of the grid within its parent view
  /// Based on `LazyVStack/alignment`
  public let alignmentGrid: HorizontalAlignment

  public init(
    columnMode: ColumnConfig.Mode,
//    columns: columns: ColumnConfig,
    spacingItem: CGFloat = 8,
    spacingGrid: CGFloat? = nil,
    alignmentItem: Alignment? = nil,
    alignmentGrid: HorizontalAlignment = .center
  ) {
//    self.columnMode = columnMode
    self.spacingGrid = spacingGrid
    self.alignmentGrid = alignmentGrid
    
    let columns = ColumnConfig(
      mode: columnMode,
      spacing: spacingItem,
      alignment: alignmentItem
    )
  }
}

extension GridConfig {

//  public var columns: [GridItem] {
//    self.columnMode.columns(
//      spacing: spacingItem,
//      alignment: alignmentItem
//    )
//  }
}

extension GridConfig: CustomStringConvertible {
  public var description: String {
    return StringGroup {
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
