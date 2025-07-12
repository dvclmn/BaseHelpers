//
//  AnalysePath.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/5/2025.
//

import SwiftUI

public struct PathDebugResult {
  public let original: Path
  public let debugPaths: DebugPaths

  public var connections: Path { debugPaths[.connection] ?? Path() }
  public var nodes: Path {
    var combined = Path()
    if let moves = debugPaths[.nodeMove] { combined.addPath(moves) }
    if let lines = debugPaths[.nodeLine] { combined.addPath(lines) }
    return combined
  }
  public var controlPoints: Path {
    var combined = Path()
    if let bezier = debugPaths[.controlBezier] { combined.addPath(bezier) }
    if let quad = debugPaths[.controlQuad] { combined.addPath(quad) }
    return combined
  }
}

//struct DebugPath {
//  var path: Path = Path()
//  let type: DebugPathElement
//
//  init(type: DebugPathElement) {
//    self.type = type
//  }
//}

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
          // Could add a visual indicator for close operations if needed
          break
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
    // Connect from last node to first control point
    if let start = startPoint, let firstControl = controlPoints.first {
      path.move(to: start)
      path.addLine(to: firstControl)
    }

    // Connect control points to end point
    for controlPoint in controlPoints {
      path.move(to: controlPoint)
      path.addLine(to: endPoint)
    }
  }
}
