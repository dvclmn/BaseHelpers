//
//  Model+GridResize.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 8/8/2025.
//

import SwiftUI

public struct GridResizeHelper {
//  let oldSize: CGSize
//  let oldDimensions: GridDimensions
  let oldGeometry: GridGeometry
  let newSize: CGSize
  let boundaryPoint: ResizePoint
  let anchorPoint: UnitPoint
}

public struct GridGeometry: Sendable, Equatable {
  let cellSize: CGSize
  let dimensions: GridDimensions
  
  init(cellSize: CGSize = .zero, dimensions: GridDimensions = .minSize) {
    self.cellSize = cellSize
    self.dimensions = dimensions
  }
  
  var canvasSize: CGSize {
    dimensions.toCGSize(withCellSize: cellSize)
  }
}
