//
//  AnalysePath.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/5/2025.
//

import SwiftUI

public struct PathAnalyser {

  /// In `ShapeDebug`, we create the path via shape.path(in: geometry.frame(in: .local)).
  /// In CanvasPathDebug, we create the path via a closure: (CGSize) -> Path.
  /// So: in both cases, PathAnalyzer just analyzes the resulting Path, not the Shape or the rect.
  /// Expect that this function is passed a fully constructed path.
  public static func analyse(_ path: Path, config: PathDebugConfig) -> DebugPaths {

    var nodePath = Path()
    var controlPointPath = Path()
    var connectionPath = Path()
    var lastNodePoint: CGPoint?

    path.forEach { element in
      switch element {
        case .move(let point):
          addPoint(to: &nodePath, at: point, pointType: config.node)
          lastNodePoint = point

        case .line(let point):
          addPoint(to: &nodePath, at: point, pointType: config.node)
          lastNodePoint = point

        case .quadCurve(let point, let controlPoint):
          addPoint(to: &nodePath, at: point, pointType: config.node)
          addPoint(to: &controlPointPath, at: controlPoint, pointType: config.controlPoint)
          if let lastNode = lastNodePoint {
            connectionPath.move(to: lastNode)
            connectionPath.addLine(to: controlPoint)
          }
          connectionPath.move(to: controlPoint)
          connectionPath.addLine(to: point)
          lastNodePoint = point

        case .curve(let point, let control1, let control2):
          addPoint(to: &nodePath, at: point, pointType: config.node)
          addPoint(to: &controlPointPath, at: control1, pointType: config.controlPoint)
          addPoint(to: &controlPointPath, at: control2, pointType: config.controlPoint)
          if let lastNode = lastNodePoint {
            connectionPath.move(to: lastNode)
            connectionPath.addLine(to: control1)
            connectionPath.move(to: point)
            connectionPath.addLine(to: control2)
          }
          lastNodePoint = point

        case .closeSubpath:
          break
      }
    }

    return DebugPaths(
      original: path,
      nodes: nodePath,
      controlPoints: controlPointPath,
      connections: connectionPath
    )

    func addPoint(
      to path: inout Path,
      at point: CGPoint,
      pointType: PointType
    ) {
      let pointSize = config.pointSize.rawValue

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
