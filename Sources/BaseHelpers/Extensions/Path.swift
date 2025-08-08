//
//  Path.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 6/7/2025.
//

import SwiftUI

extension Path {
  
  public init(fromSize size: CGSize) {
    self.init { path in
      path.addRect(CGRect(origin: .zero, size: size))
    }
  }
  
  public static func createGrid(
    columns: Int,
    rows: Int,
    cellSize: CGSize,
    containerSize: CGSize
  ) -> Path {
    Path { p in
      /// Horizontal lines
      for row in 0...rows {
        let y = min(CGFloat(row) * cellSize.height, containerSize.height)
        p.move(to: CGPoint(x: 0, y: y))
        p.addLine(to: CGPoint(x: containerSize.width, y: y))
      }
      
      /// Vertical lines
      for column in 0...columns {
        let x = min(CGFloat(column) * cellSize.width, containerSize.width)
        p.move(to: CGPoint(x: x, y: 0))
        p.addLine(to: CGPoint(x: x, y: containerSize.height))
      }
    }
  }

  public mutating func addDot(at point: CGPoint, radius: CGFloat, using type: DebugPathElement) {
    let rect = CGRect(
      x: point.x - radius / 2,
      y: point.y - radius / 2,
      width: radius,
      height: radius
    )
    addPath(type.shape.shapePath(in: rect))
  }

  public mutating func addConnections(
    from start: CGPoint,
    to end: CGPoint,
    controlPoints: [CGPoint]
  ) {
    if controlPoints.count == 1 {
      move(to: start)
      addLine(to: controlPoints[0])
      move(to: controlPoints[0])
    } else if controlPoints.count == 2 {
      move(to: start)
      addLine(to: controlPoints[0])
      move(to: controlPoints[1])
      addLine(to: end)
    }
  }

  //  private func drawLinesForGrid(
  //    path p: inout Path,
  //    axis: Axis,
  //    count: Int,
  //    cellSize: CGSize,
  //    containerSize: CGSize
  //  ) {
  //    let cellLength = axis.length(size: cellSize)
  //    let containerLength = axis.length(size: containerSize)
  //
  //    for segment in 0...count {
  //      let dimension = CGFloat(segment) * cellLength
  //      p.move(to: CGPoint(x: x, y: 0))
  //      p.addLine(to: CGPoint(x: x, y: containerSize.height))
  //    }
  //  }

}
