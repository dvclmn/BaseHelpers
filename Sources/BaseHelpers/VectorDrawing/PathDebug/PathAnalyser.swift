//
//  AnalysePath.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/5/2025.
//

import SwiftUI

struct DebugPath {
  var path: Path = Path()
  let type: DebugPathType

  init(type: DebugPathType) {
    self.type = type
  }
}

extension Path {

  //  let originalPath:

  /// In `ShapeDebug`, we create the path via shape.path(in: geometry.frame(in: .local)).
  /// In CanvasPathDebug, we create the path via a closure: (CGSize) -> Path.
  /// So: in both cases, PathAnalyzer just analyzes the resulting Path, not the Shape or the rect.
  /// Expect that this function is passed a fully constructed path.
  public func analyse() -> [DebugPath] {

    var nodeMovePath = DebugPath(type: .node(.move))
    var nodeLinePath = DebugPath(type: .node(.line))
    var bezierPath = DebugPath(type: .control(.bezier))
    var quadPath = DebugPath(type: .control(.quadratic))
    var connectionPath = DebugPath(type: .connection)
    //    var nodePath = Path()
    //    var controlPointPath = Path()
    //    var connectionPath = Path()
    var lastNodePoint: CGPoint?

    self.forEach { element in
      //      element.addPoint(to: &nodePath, at: element., size: <#T##PointSize#>)
      switch element {

        case .move(let point):
          addPoint(to: &nodeMovePath.path, at: point, element: element)
          lastNodePoint = point

        case .line(let point):
          addPoint(to: &nodeLinePath.path, at: point, element: element)
          lastNodePoint = point

        case .quadCurve(let point, let controlPoint):
          addPoint(to: &quadPath.path, at: point, element: element)
          addPoint(to: &quadPath.path, at: controlPoint, element: element)
          if let lastNode = lastNodePoint {
            connectionPath.path.move(to: lastNode)
            connectionPath.path.addLine(to: controlPoint)
          }
          connectionPath.path.move(to: controlPoint)
          connectionPath.path.addLine(to: point)
          lastNodePoint = point

        case .curve(let point, let control1, let control2):
          addPoint(to: &nodeLinePath.path, at: point, element: element)
          addPoint(to: &bezierPath.path, at: control1, element: element)
          addPoint(to: &bezierPath.path, at: control2, element: element)
          if let lastNode = lastNodePoint {
            connectionPath.path.move(to: lastNode)
            connectionPath.path.addLine(to: control1)
            connectionPath.path.move(to: point)
            connectionPath.path.addLine(to: control2)
          }
          lastNodePoint = point

        case .closeSubpath:
          break

      }
    }

    return [ nodeMovePath, nodeLinePath, bezierPath, quadPath, connectionPath ]
//    return DebugPaths(
//      original: self,
//      nodes: nodePath,
//      controlPoints: controlPointPath,
//      connections: connectionPath
//    )

    func addPoint(
      to path: inout Path,
      at point: CGPoint,
      type: DebugPathType
//      element: Path.Element
        //      pointType: PointType
    ) {
      let pointSize = PointSize.normal.rawValue
      //      let pointSize = config.pointSize(for: pointType)

      let rect = CGRect(
        x: point.x - pointSize / 2,
        y: point.y - pointSize / 2,
        width: pointSize,
        height: pointSize)

      path.addPath(type.)
//      switch element.debugStyle.shape {
//        case .circle:
//          path.
//          path.addEllipse(in: rect)
//        case .square:
//          path.addRect(rect)
//      }
    }
  }
}
