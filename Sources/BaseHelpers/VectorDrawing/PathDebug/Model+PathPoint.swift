//
//  Model+PathPoint.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/7/2025.
//

import SwiftUI

public enum DebugPathType {
  case node(NodeType)
  case control(CurveType)
  case connection
  case close

  public init(fromElement element: Path.Element) {
    self =
      switch element {
        case .move: .node(.move)
        case .line: .node(.line)
        case .quadCurve: .control(.quadratic)
        case .curve: .control(.bezier)
        case .closeSubpath: .close
      }
  }

  //  public var shape: PointShape {
  //    switch self {
  //      case .node: .square
  //      case .control: .circle
  //      case .connection: .circle
  //      case .close: .cross
  //    }
  //  }

  public var displayColour: Color {
    switch self {
      case .node(let nodeType):
        switch nodeType {
          case .move:
            .cyan
          case .line:
            .blue
        }
      case .control(let curveType):
        switch curveType {
          case .bezier:
            .brown
          case .quadratic:
            .orange
        }
        
      case .connection: .red
      case .close:
        .gray
    }
  }

}

public enum NodeType {
  case move
  case line

  public var shape: PointShape {
    switch self {
      case .move: .square
      case .line: .square
    }
  }

}
public enum CurveType {
  case bezier
  case quadratic

  public var shape: PointShape {
    switch self {
      case .bezier: .circle
      case .quadratic: .circle
    }
  }
}

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
