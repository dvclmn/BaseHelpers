//
//  AnalysePath.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/5/2025.
//

import SwiftUI

extension Path.Element {
  public func debugStyle(size: PointSize = .normal) -> PointStyle {
    switch self {
      case .move:
        PointStyle(
          displayName: self.displayName,
          shape: .square,
          colour: .blue,
          size: size
        )
      case .line:
        PointStyle(
          displayName: self.displayName,
          shape: .square,
          colour: .cyan,
          size: size
        )

      case .quadCurve:
        PointStyle(
          displayName: self.displayName,
          shape: .circle,
          colour: .orange,
          size: size
        )

      case .curve:
        PointStyle(
          displayName: self.displayName,
          shape: .circle,
          colour: .brown,
          size: size
        )

      case .closeSubpath:
        PointStyle(
          displayName: self.displayName,
          shape: .circle,
          colour: .gray,
          size: size
        )
    }

  }

  //  public func addPoint(
  //    to path: inout Path,
  //    at point: CGPoint,
  //    size: PointSize
  //  ) {
  //
  //    //    let point = switch self {
  //    //      case .move(let to):
  //    //        <#code#>
  //    //      case .line(let to):
  //    //        <#code#>
  //    //      case .quadCurve(let to, let control):
  //    //        <#code#>
  //    //      case .curve(let to, let control1, let control2):
  //    //        <#code#>
  //    //      case .closeSubpath:
  //    //        <#code#>
  //    //    }
  //    //
  //    let pointSize = size.rawValue
  //    let style = self.debugStyle(size: size)
  //
  //    let rect = CGRect(
  //      x: point.x - pointSize / 2,
  //      y: point.y - pointSize / 2,
  //      width: pointSize,
  //      height: pointSize)
  //
  //    switch style.shape {
  //      case .circle:
  //        path.addEllipse(in: rect)
  //      case .square:
  //        path.addRect(rect)
  //    }
  //  }

  public var displayName: String {
    switch self {
      case .move(let point): "Move(\(point))"
      case .line(let point): "Line(\(point))"
      case .quadCurve(let point, let control): "QuadCurve(\(point),\(control))"
      case .curve(let point, let control1, let control2): "Curve(\(point),\(control1),\(control2))"
      case .closeSubpath: "Close"
    }
  }

}

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
      //      element.addPoint(to: &nodePath, at: element., size: <#T##PointSize#>)
      switch element {

        case .move(let point):
          addPoint(to: &nodePath, at: point, pointType: .node)
          lastNodePoint = point

        case .line(let point):
          addPoint(to: &nodePath, at: point, pointType: .node)
          lastNodePoint = point

        case .quadCurve(let point, let controlPoint):
          addPoint(to: &nodePath, at: point, pointType: .node)
          addPoint(to: &controlPointPath, at: controlPoint, pointType: .control)
          if let lastNode = lastNodePoint {
            connectionPath.move(to: lastNode)
            connectionPath.addLine(to: controlPoint)
          }
          connectionPath.move(to: controlPoint)
          connectionPath.addLine(to: point)
          lastNodePoint = point

        case .curve(let point, let control1, let control2):
          addPoint(to: &nodePath, at: point, pointType: .node)
          addPoint(to: &controlPointPath, at: control1, pointType: .control)
          addPoint(to: &controlPointPath, at: control2, pointType: .control)
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
      let pointSize = element.
//      let pointSize = config.pointSize(for: pointType)

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
