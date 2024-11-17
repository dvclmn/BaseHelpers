//
//  Models.swift
//  Components
//
//  Created by Dave Coleman on 30/9/2024.
//

import SwiftUI

public typealias ColouredPoint = (point: CGPoint, color: Color)

public struct DebugPaths {
  public let original: Path
  public let nodes: Path
  public let controlPoints: Path
  public let connections: Path

}

public protocol PointType {
  var shape: PointShape { get }
  var colour: Color { get }
}

public struct PathDebugConfig {
  
  let pointSize: PointSize
  
  let stroke: Stroke
  let node: Node
  let controlPoint: ControlPoint
  var labelFontSize: CGFloat
  
  public init(
    pointSize: PointSize = .normal,
    stroke: Stroke = .init(),
    node: Node = .init(),
    controlPoint: ControlPoint = .init(),
    labelFontSize: CGFloat = 12
  ) {
    self.pointSize = pointSize
    self.stroke = stroke
    self.node = node
    self.controlPoint = controlPoint
    self.labelFontSize = labelFontSize
  }
}

public enum PointShape {
  case circle
  case square
}
public enum PointSize {
  case mini
  case small
  case normal
  case large
  case huge
  
  var value: CGFloat {
    switch self {
      case .mini: 2
      case .small: 4
      case .normal: 6
      case .large: 10
      case .huge: 14
    }
  }
}

public struct Stroke {
  var width: CGFloat
  var colour: Color
  
  public init(width: CGFloat = 1, colour: Color = .gray) {
    self.width = width
    self.colour = colour
  }
}

public struct Node: PointType {
  public var shape: PointShape
  public var colour: Color
  
  public init(shape: PointShape = .square, colour: Color = .brown) {
    self.shape = shape
    self.colour = colour
  }
}

public struct ControlPoint: PointType {
  public var shape: PointShape
  public var colour: Color
  public var guideColour: Color
  
  public init(
    shape: PointShape = .circle,
    colour: Color = .green,
    guideColour: Color = .orange
  ) {
    self.shape = shape
    self.colour = colour
    self.guideColour = guideColour
  }
}
