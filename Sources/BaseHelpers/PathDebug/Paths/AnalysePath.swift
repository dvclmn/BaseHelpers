//
//  AnalysePath.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/5/2025.
//

import SwiftUI

public struct PathAnalyzer {
  
  // Expect that this function is passed a fully constructed path.
  public static func analyze(_ path: Path, config: PathDebugConfig) -> DebugPaths {

//    let originalPath = shape.path(in: rect)
    var nodePath = Path()
    var controlPointPath = Path()
    var connectionPath = Path()


    var lastNodePoint: CGPoint?

    print("PathDebugger: Starting path analysis")

    originalPath.forEach { element in
      switch element {
        case .move(let to):
          addPoint(to: &nodePath, at: to, pointType: config.node)
          lastNodePoint = to

        case .line(let to):
          addPoint(to: &nodePath, at: to, pointType: config.node)
          lastNodePoint = to

        case .quadCurve(let to, let control):
          addPoint(to: &nodePath, at: to, pointType: config.node)
          addPoint(to: &controlPointPath, at: control, pointType: config.controlPoint)
          if let lastNode = lastNodePoint {
            connectionPath.move(to: lastNode)
            connectionPath.addLine(to: control)
          }
          connectionPath.move(to: control)
          connectionPath.addLine(to: to)
          lastNodePoint = to

        case .curve(let to, let control1, let control2):
          addPoint(to: &nodePath, at: to, pointType: config.node)
          addPoint(to: &controlPointPath, at: control1, pointType: config.controlPoint)
          addPoint(to: &controlPointPath, at: control2, pointType: config.controlPoint)
          if let lastNode = lastNodePoint {
            connectionPath.move(to: lastNode)
            connectionPath.addLine(to: control1)
            connectionPath.move(to: to)
            connectionPath.addLine(to: control2)
          }
          lastNodePoint = to

        case .closeSubpath:
          break
      }
    }

    func addPoint(
      to path: inout Path,
      at point: CGPoint,
      pointType: PointType
    ) {
      let pointSize = config.pointSize.value

      let rect = CGRect(
        x: point.x - pointSize / 2,
        y: point.y - pointSize / 2,
        width: pointSize,
        height: pointSize)

      switch pointType.shape {
        case .circle:
          path.addEllipse(in: rect)
        case .square:
          path.addRect(rect)
      }
    }
  }
}
