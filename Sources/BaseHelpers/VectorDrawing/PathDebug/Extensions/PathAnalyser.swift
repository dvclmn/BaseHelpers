//
//  AnalysePath.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/5/2025.
//

import SwiftUI

public typealias DebugPaths = [DebugPathElement: Path]

extension Path {
  public func analyse(pointSize: PointSize = .normal) -> PathDebugResult {
    var debugPaths: DebugPaths = Dictionary(
      uniqueKeysWithValues: DebugPathElement.allCases.map { ($0, Path()) }
    )

    var lastNodePoint: CGPoint?
    let pointRadius = pointSize.rawValue

    self.forEach { element in
      switch element {
        case .move(let point):
          addPoint(
            to: &debugPaths[.nodeMove]!, at: point,
            element: .nodeMove, pointRadius: pointRadius)
          lastNodePoint = point

        case .line(let point):
          addPoint(
            to: &debugPaths[.nodeLine]!, at: point,
            element: .nodeLine, pointRadius: pointRadius)
          lastNodePoint = point

        case .quadCurve(let point, let controlPoint):
          // Add node point
          addPoint(
            to: &debugPaths[.nodeLine]!, at: point,
            element: .nodeLine, pointRadius: pointRadius)
          // Add control point
          addPoint(
            to: &debugPaths[.controlQuad]!, at: controlPoint,
            element: .controlQuad, pointRadius: pointRadius)
          // Add connection lines
          addConnections(
            to: &debugPaths[.connection]!,
            from: lastNodePoint, to: point,
            controlPoints: [controlPoint])
          lastNodePoint = point

        case .curve(let point, let control1, let control2):
          // Add node point
          addPoint(
            to: &debugPaths[.nodeLine]!, at: point,
            element: .nodeLine, pointRadius: pointRadius)
          // Add control points
          addPoint(
            to: &debugPaths[.controlBezier]!, at: control1,
            element: .controlBezier, pointRadius: pointRadius)
          addPoint(
            to: &debugPaths[.controlBezier]!, at: control2,
            element: .controlBezier, pointRadius: pointRadius)
          // Add connection lines
          addConnections(
            to: &debugPaths[.connection]!,
            from: lastNodePoint, to: point,
            controlPoints: [control1, control2])
          lastNodePoint = point

        case .closeSubpath:
          // Add a visual indicator for close operations
          if let lastNode = lastNodePoint {
            addPoint(
              to: &debugPaths[.close]!, at: lastNode,
              element: .close, pointRadius: pointRadius)
          }
          lastNodePoint = nil  // Reset for new subpath
      }
    }

    return PathDebugResult(original: self, debugPaths: debugPaths)
  }

  private func addPoint(
    to path: inout Path,
    at point: CGPoint,
    element: DebugPathElement,
    pointRadius: CGFloat
  ) {
    let rect = CGRect(
      x: point.x - pointRadius / 2,
      y: point.y - pointRadius / 2,
      width: pointRadius,
      height: pointRadius
    )

    path.addPath(element.shape.shapePath(in: rect))
  }

  private func addConnections(
    to path: inout Path,
    from startPoint: CGPoint?,
    to endPoint: CGPoint,
    controlPoints: [CGPoint]
  ) {

    guard let start = startPoint else { return }

    if controlPoints.count == 1 {
      
      let control = controlPoints[0]
      path.move(to: start)
      path.addLine(to: control)
      path.move(to: control)

    } else if controlPoints.count == 2 {
      
      let control1 = controlPoints[0]
      let control2 = controlPoints[1]

      path.move(to: start)
      path.addLine(to: control1)
      path.move(to: control1)
      path.move(to: control2)
      path.addLine(to: endPoint)
    }
  }
}
