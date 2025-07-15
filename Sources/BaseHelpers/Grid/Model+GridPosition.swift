//
//  Model+GridPosition.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/7/2025.
//

import SwiftUI

/// Represents a position in a 2D Grid (rows and columns)
public struct GridPosition: GridBase {
  public let row: Int
  public let column: Int

  public init(row: Int, column: Int) {
    self.row = row
    self.column = column
  }

  /// `point` must already be mapped to local Canvas space
  public init(
    point: CGPoint,
    cellSize: CGSize
  ) {
    let position = GridPosition.fromCGPoint(point, at: cellSize)
    self = position
  }
}

extension GridPosition {

  /// Converts grid position to canvas-space point
  /// - Parameter cellSize: The size of each grid cell
  /// - Returns: The top-left point of the cell in canvas coordinates
  public func toCGPoint(cellSize: CGSize) -> CGPoint {
    CGPoint(
      x: CGFloat(column) * cellSize.width,
      y: CGFloat(row) * cellSize.height
    )
  }

  /// `cellSize` is the width and height in points
  /// of a single cell in the current `GridCanvas`.
  /// It is not affected by zoom, it operates in local
  /// Canvas Space
  public static func fromCGPoint(
    _ point: CGPoint,
    at cellSize: CGSize
  ) -> GridPosition {
    let row = Int(floor(point.y / cellSize.height))
    let col = Int(floor(point.x / cellSize.width))

    return GridPosition(row: row, column: col)
  }

  public func neighbour(at edge: CellEdge) -> GridPosition {
    switch edge {
      case .top: return GridPosition(row: row - 1, column: column)
      case .bottom: return GridPosition(row: row + 1, column: column)
      case .left: return GridPosition(row: row, column: column - 1)
      case .right: return GridPosition(row: row, column: column + 1)
    }
  }

  public func toCGRect(cellSize: CGSize) -> CGRect {
    CGRect(
      x: CGFloat(column) * cellSize.width,
      y: CGFloat(row) * cellSize.height,
      width: cellSize.width,
      height: cellSize.height
    )
  }

  public func toIndex(columns: Int) -> Int {
    row * columns + column
  }

  public static var zero: GridPosition {
    GridPosition(row: 0, column: 0)
  }
  /// Basic offset methods
  public func offsetBy(row deltaRow: Int, col deltaCol: Int) -> GridPosition {
    GridPosition(row: row + deltaRow, column: column + deltaCol)
  }

  public mutating func offsetting(by delta: GridPosition) {
    let current = self
    self = current + delta
  }

  public mutating func offsetting(_ direction: Direction, by delta: Int = 1) {
    let (newCol, newRow) = direction.offset(x: column, y: row, by: delta)
    self = GridPosition(row: newRow, column: newCol)
  }

  public func isValidWithin(grid: GridDimensions) -> Bool {
    return grid.contains(self)
  }

}

public func + (lhs: GridPosition, rhs: GridPosition) -> GridPosition {
  return GridPosition(
    row: lhs.row + rhs.row,
    column: lhs.column + rhs.column
  )
}

extension Collection where Element == GridPosition {

  /// This version of `toCGRect` skips needing to create intermediate
  /// `GridRect`, instead just creating one at the end.
  public func toCGRect(cellSize: CGSize) -> CGRect {
    guard let first = self.first else { return .null }

    var minRow = first.row
    var maxRow = first.row
    var minCol = first.column
    var maxCol = first.column

    for position in self.dropFirst() {
      minRow = Swift.min(minRow, position.row)
      maxRow = Swift.max(maxRow, position.row)
      minCol = Swift.min(minCol, position.column)
      maxCol = Swift.max(maxCol, position.column)
    }

    let origin = GridPosition(row: minRow, column: minCol)
    let size = GridDimensions(
      columns: maxCol - minCol + 1,
      rows: maxRow - minRow + 1
    )

    let gridRect = GridRect(origin: origin, size: size)
    return gridRect.toCGRect(cellSize: cellSize)
  }
}

//extension Collection where Element == GridPosition {
//  /// Returns a CGRect in pixel coordinates that encompasses all GridPositions.
//  public func toCGRect(cellSize: CGSize) -> CGRect {
//    guard let first = self.first else { return .null }
//
//    let boundingRect = self.dropFirst().reduce(
//      into: GridRect(origin: first, size: .zero)
//    ) { partialResult, position in
//      partialResult = GridRect(boundingPositions: partialResult.origin, position)
//    }
//
//    return boundingRect.toCGRect(cellSize: cellSize)
//  }
//}

extension GridPosition: CustomStringConvertible {
  public var description: String {
    """
    GridPosition[X: \(column), Y: \(row)]
    """
  }
}

public enum CellEdge: CaseIterable {
  case top, bottom, left, right

  public func path(in rect: CGRect) -> Path {
    switch self {
      case .top:
        return Path {
          $0.move(to: rect.minXminY)
          $0.addLine(to: rect.maxXminY)
        }
      case .bottom:
        return Path {
          $0.move(to: rect.minXmaxY)
          $0.addLine(to: rect.maxXmaxY)
        }
      case .left:
        return Path {
          $0.move(to: rect.minXminY)
          $0.addLine(to: rect.minXmaxY)
        }
      case .right:
        return Path {
          $0.move(to: rect.maxXminY)
          $0.addLine(to: rect.maxXmaxY)
        }
    }
  }
}
