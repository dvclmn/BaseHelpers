//
//  Model+GridResize.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 8/8/2025.
//

import SwiftUI

public struct GridResizeHelper {
  let oldGeometry: GridGeometry
  let newSize: CGSize
  let boundaryPoint: GridBoundaryPoint
  let anchorPoint: UnitPoint

  public init(
    oldGeometry: GridGeometry,
    newSize: CGSize,
    boundaryPoint: GridBoundaryPoint,
    anchorPoint: UnitPoint
  ) {
    self.oldGeometry = oldGeometry
    self.newSize = newSize
    self.boundaryPoint = boundaryPoint
    self.anchorPoint = anchorPoint
  }
}
extension GridResizeHelper {

  var cellSize: CGSize { oldGeometry.cellSize }

  public var resizeDelta: GridDelta {

    let oldDimensions = oldGeometry.dimensions
    let newDimensions = GridDimensions(
      size: newSize,
      cellSize: cellSize,
    )
    assert(
      boundaryPoint
        .isValidSizeDelta(
          from: oldDimensions,
          to: newDimensions
        ),
      "Invalid size delta for boundary point"
    )
    let delta = GridDelta(old: oldDimensions, new: newDimensions)

    return delta
  }

  public func resize(_ artwork: inout GridMatrix) {
    artwork.resize(by: resizeDelta, at: affectedEdges)
  }

  public var affectedEdges: GridEdge.Set { boundaryPoint.edgesToResize(anchor: anchorPoint) }
}

// MARK: - Grid Geometry
public struct GridGeometry: Sendable, Equatable {
  public let cellSize: CGSize
  public let dimensions: GridDimensions

  public static let zero = GridGeometry(
    cellSize: .zero,
    dimensions: .minSize
  )

  public init(
    cellSize: CGSize,
    dimensions: GridDimensions
  ) {
    self.cellSize = cellSize
    self.dimensions = dimensions
  }

  public var canvasSize: CGSize {
    dimensions.toCGSize(withCellSize: cellSize)
  }
}
