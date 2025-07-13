//
//  AnalysePath.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/5/2025.
//

import SwiftUI

public typealias DebugPaths = [DebugPathElement: Path]

extension Path {

  func analyse(pointSize: PointSize = .normal) -> PathDebugResult {
    var debugPaths: DebugPaths = Dictionary(
      uniqueKeysWithValues: DebugPathElement.allCases.map { ($0, Path()) }
    )
    var labelPoints: [LabelledPoint] = []

    var lastNodePoint: CGPoint?
    let radius = pointSize.rawValue

    self.forEach { element in
      let info = DebugPathInfo(element: element, previousPoint: lastNodePoint)

      for (type, point) in info.pointsToMark {
        debugPaths[type, default: Path()].addDot(at: point, radius: radius, using: type)
        labelPoints.append(LabelledPoint(point: point, element: type))
      }

      if let (from, to, controls) = info.connection {
        debugPaths[.connection, default: Path()].addConnections(from: from, to: to, controlPoints: controls)
      }

      lastNodePoint = info.newLastPoint
    }

    return PathDebugResult(
      original: self,
      debugPaths: debugPaths,
      labelPoints: labelPoints
    )
  }

}
