//
//  Model+GridGeometry.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/7/2025.
//

import Foundation

public enum GridGeometry {
  public static func rect(for position: GridPosition, cellSize: CGSize) -> CGRect {
    CGRect(
      x: CGFloat(position.column) * cellSize.width,
      y: CGFloat(position.row) * cellSize.height,
      width: cellSize.width,
      height: cellSize.height
    )
  }
  
  public static func position(at point: CGPoint, cellSize: CGSize) -> GridPosition {
    GridPosition(
      row: Int(point.y / cellSize.height),
      column: Int(point.x / cellSize.width)
    )
  }
  
//  static func gridRect(for rect: CGRect, cellSize: CGSize) -> GridRect {
//    let topLeft = position(at: rect.origin, cellSize: cellSize)
//    let bottomRight = position(at: CGPoint(x: rect.maxX, y: rect.maxY), cellSize: cellSize)
//    let width = bottomRight.column - topLeft.column + 1
//    let height = bottomRight.row - topLeft.row + 1
//    return GridRect(origin: topLeft, size: GridDimensions(columns: width, rows: height))
//  }
//  
  public static func gridRect(for rect: CGRect, cellSize: CGSize) -> GridRect {
    let minX = rect.minX
    let minY = rect.minY
    let maxX = rect.maxX
    let maxY = rect.maxY
    
    let topLeft = GridPosition(
      row: Int(floor(minY / cellSize.height)),
      column: Int(floor(minX / cellSize.width))
    )
    let bottomRight = GridPosition(
      row: Int(floor(maxY / cellSize.height)),
      column: Int(floor(maxX / cellSize.width))
    )
    
    let columns = bottomRight.column - topLeft.column + 1
    let rows = bottomRight.row - topLeft.row + 1
    
    return GridRect(origin: topLeft, size: GridDimensions(columns: columns, rows: rows))
  }
}
