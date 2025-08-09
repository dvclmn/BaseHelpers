//
//  Model+CellSnapped.swift
//  DrawString
//
//  Created by Dave Coleman on 7/8/2025.
//

import Foundation

public enum SnapStrategy {
  case floor
  case ceil
  case round
}

extension CGSize {

  public func quantisedCanvasSize(
    cellSize: CGSize,
    strategy: SnapStrategy
  ) -> CGSize {
    let snappedCounts = cellSnappedDimensions(cellSize: cellSize, strategy: strategy)
    return CGSize(
      width: CGFloat(snappedCounts.columns) * cellSize.width,
      height: CGFloat(snappedCounts.rows) * cellSize.height
    )
  }

  public func cellCount(
    alongAxis axis: GridAxis,
    cellSize: CGSize,
    strategy: SnapStrategy
  ) -> Int {
    let dimensions = cellSnappedDimensions(
      cellSize: cellSize,
      strategy: strategy
    )
    return switch axis {
      case .column: dimensions.columns
      case .row: dimensions.rows
    }
  }

  public func cellSnappedDimensions(
    cellSize: CGSize,
    strategy: SnapStrategy
  ) -> GridDimensions {
    let colsRaw = self.width / cellSize.width
    let rowsRaw = self.height / cellSize.height

    let cols: Int
    let rows: Int

    switch strategy {
      case .floor:
        cols = Int(floor(colsRaw))
        rows = Int(floor(rowsRaw))
      case .ceil:
        cols = Int(ceil(colsRaw))
        rows = Int(ceil(rowsRaw))
      case .round:
        cols = Int(colsRaw.rounded())
        rows = Int(rowsRaw.rounded())
    }

    return GridDimensions(columns: cols, rows: rows)
  }

}
