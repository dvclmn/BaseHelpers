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

  public mutating func addDot(
    at point: CGPoint,
    radius: CGFloat,
    using type: DebugPathElement
  ) {
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

//  // MARK: - Draw Waveform
//  public static func generateWaveform(
//    in rect: CGRect,
//    sampleCount: Int,
//    renderer: any WaveRenderer
//  ) -> Path {
//    var path = Path()
//
//    guard rect.width > 1, sampleCount > 1 else { return path }
//
//    let midY = rect.midY
//    let step = rect.width / CGFloat(sampleCount - 1)
//    var x: CGFloat = rect.minX
//    var first = true
//
//    for i in 0..<sampleCount {
//      let normalizedPosition = CGFloat(i) / CGFloat(sampleCount - 1)
//      let waveValue = renderer.evaluateWave(at: normalizedPosition)
//      let y = midY + waveValue
//
//      if first {
//        path.move(to: CGPoint(x: x, y: y))
//        first = false
//      } else {
//        path.addLine(to: CGPoint(x: x, y: y))
//      }
//      x += step
//    }
//
//    return path
//  }

}
