//
//  Model+PathPoint.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/7/2025.
//

import SwiftUI

public enum DebugPathElement: Hashable, CaseIterable {
  case nodeMove
  case nodeLine
  case controlBezier
  case controlQuad
  case connection
  case close

  public init(fromElement element: Path.Element) {
    self =
      switch element {
        case .move: .nodeMove
        case .line: .nodeLine
        case .quadCurve: .controlQuad
        case .curve: .controlBezier
        case .closeSubpath: .close
      }
  }

  public var shape: PointShape {
    switch self {
      case .nodeMove: .triangle
      case .nodeLine: .square
      case .controlBezier, .controlQuad: .circle
      case .connection, .close: .cross
    }
  }

  public var displayColour: Color {
    switch self {
      case .nodeMove: .cyan
      case .nodeLine: .blue
      case .controlBezier: .brown
      case .controlQuad: .orange
      case .connection: .red
      case .close: .gray
    }
  }

  public func draw(
    shape: any Shape,
    rect: CGRect,
    element: (Path) -> Void
  ) {
    let debugResult = shape.path(in: rect).analyse()
    guard let path = debugResult.debugPaths[self] else { return }
    element(path)
  }

}

public enum PointSize: CGFloat {
  case mini = 2
  case small = 4
  case normal = 6
  case large = 10
  case huge = 14
}

//public struct DebugPaths {
//  public let original: Path
//  public let nodes: Path
//  public let controlPoints: Path
//  public let connections: Path
//}

//public protocol PathPoint {
//  var type: PointType { get }
//  var style: PointStyle { get }
//}

//public struct PointStyle {
//  public let displayName: String
//  public let shape: PointShape
//  public let colour: Color
//  public let size: PointSize
//
//  //  public init(
//  //    colour: Color = .brown,
//  //    size: PointSize = .normal,
//  //  ) {
//  //    self.colour = colour
//  //    self.size = size
//  //  }
//}

//public struct ControlPoint: PathPoint {
//  public var type: PointType { .control }
//  public let style: PointStyle
//
//  public init(
//    style: PointStyle = .init()
//  ) {
//    self.style = style
//  }
//
//}
//public struct Node: PathPoint {
//  public var type: PointType { .node }
//  public let style: PointStyle
//
//  public init(
//    style: PointStyle = .init()
//  ) {
//    self.style = style
//  }
//
//}
