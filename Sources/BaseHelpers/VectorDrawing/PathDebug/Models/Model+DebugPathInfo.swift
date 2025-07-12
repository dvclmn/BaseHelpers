//
//  Model+DebugPathInfo.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/7/2025.
//

import SwiftUI

public struct DebugPathInfo {
  let pointsToMark: [(DebugPathElement, CGPoint)]
  let connection: (from: CGPoint, to: CGPoint, controlPoints: [CGPoint])?
  let newLastPoint: CGPoint?
  
  public init(element: Path.Element, previousPoint: CGPoint?) {
    switch element {
      case .move(let point):
        pointsToMark = [(.nodeMove, point)]
        connection = nil
        newLastPoint = point
        
      case .line(let point):
        pointsToMark = [(.nodeLine, point)]
        connection = nil
        newLastPoint = point
        
      case .quadCurve(let point, let control):
        pointsToMark = [
          (.nodeLine, point),
          (.controlQuad, control)
        ]
        connection = previousPoint.map { ($0, point, [control]) }
        newLastPoint = point
        
      case .curve(let point, let control1, let control2):
        pointsToMark = [
          (.nodeLine, point),
          (.controlBezier, control1),
          (.controlBezier, control2)
        ]
        connection = previousPoint.map { ($0, point, [control1, control2]) }
        newLastPoint = point
        
      case .closeSubpath:
        pointsToMark = previousPoint.map { [(.close, $0)] } ?? []
        connection = nil
        newLastPoint = nil
    }
  }
}
