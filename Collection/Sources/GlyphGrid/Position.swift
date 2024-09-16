//
//  Position.swift
//  SwiftBox
//
//  Created by Dave Coleman on 29/8/2024.
//

import SwiftUI

extension GlyphGrid {
  
  
  
  //  public static let example: GlyphGrid = GlyphGrid(cell: .example, dimensions: .example, type: .canvas)
  
  public func gridPosition(for location: CGPoint, zoomLevel: CGFloat = 1.0) -> GridPosition {
    switch type {
      case .interface:
        return GridPosition(
          row: Int(location.y / cell.size.height),
          col: Int(location.x / cell.size.width)
        )
      case .canvas:
        return GridPosition(
          row: Int(location.y / (cell.size.height * zoomLevel)),
          col: Int(location.x / (cell.size.width * zoomLevel))
        )
    }
  }
  
  public func gridPosition(for location: CGPoint) -> GridPosition {
    let row = Int(location.y / cell.size.height)
    let col = Int(location.x / cell.size.width)
    return GridPosition(row: row, col: col)
  }
  
  public func isValidPosition(_ position: GridPosition) -> Bool {
    return position.row >= 0 && position.row < dimensions.rows &&
    position.col >= 0 && position.col < dimensions.columns
  }
  
  public func cgRect(for position: GridPosition) -> CGRect {
    let origin = CGPoint(x: CGFloat(position.col) * cell.size.width,
                         y: CGFloat(position.row) * cell.size.height)
    return CGRect(origin: origin, size: cell.size)
  }
  
}
