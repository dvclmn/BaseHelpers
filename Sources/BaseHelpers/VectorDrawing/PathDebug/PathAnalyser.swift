//
//  AnalysePath.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/5/2025.
//

import SwiftUI

extension Path {
  
//  let originalPath:

  /// In `ShapeDebug`, we create the path via shape.path(in: geometry.frame(in: .local)).
  /// In CanvasPathDebug, we create the path via a closure: (CGSize) -> Path.
  /// So: in both cases, PathAnalyzer just analyzes the resulting Path, not the Shape or the rect.
  /// Expect that this function is passed a fully constructed path.
  public static func analyse(_ path: Path) -> DebugPaths {

    var nodePath = Path()
    var controlPointPath = Path()
    var connectionPath = Path()
    var lastNodePoint: CGPoint?

    path.forEach { element in
      //      element.addPoint(to: &nodePath, at: element., size: <#T##PointSize#>)
      switch element {

        case .move(let point):
          addPoint(to: &nodePath, at: point, element: element)
          lastNodePoint = point

        case .line(let point):
          addPoint(to: &nodePath, at: point, element: element)
          lastNodePoint = point

        case .quadCurve(let point, let controlPoint):
          addPoint(to: &nodePath, at: point, element: element)
          addPoint(to: &controlPointPath, at: controlPoint, element: element)
          if let lastNode = lastNodePoint {
            connectionPath.move(to: lastNode)
            connectionPath.addLine(to: controlPoint)
          }
          connectionPath.move(to: controlPoint)
          connectionPath.addLine(to: point)
          lastNodePoint = point

        case .curve(let point, let control1, let control2):
          addPoint(to: &nodePath, at: point, element: element)
          addPoint(to: &controlPointPath, at: control1, element: element)
          addPoint(to: &controlPointPath, at: control2, element: element)
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
      element: Path.Element
        //      pointType: PointType
    ) {
      let pointSize = element.debugStyle.size.rawValue
      //      let pointSize = config.pointSize(for: pointType)

      let rect = CGRect(
        x: point.x - pointSize / 2,
        y: point.y - pointSize / 2,
        width: pointSize,
        height: pointSize)

      switch element.debugStyle.shape {
        case .circle:
          path.addEllipse(in: rect)
        case .square:
          path.addRect(rect)
      }
    }
  }
}
