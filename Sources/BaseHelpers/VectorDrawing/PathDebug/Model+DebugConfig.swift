//
//  Model+DebugConfig.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/7/2025.
//

import SwiftUI

public struct PathDebugConfig {
  
  
//  public let stroke: Stroke
  public let pathStyle: PathStyle
  public let node: Node
  public let controlPoint: ControlPoint
  public let labelFontSize: CGFloat
  public let guideColour: Color
  
  public init(
    pointSize: PointSize = .normal,
    pathStyle: PathStyle = .init(),
    node: Node = .init(),
    controlPoint: ControlPoint = .init(),
    labelFontSize: CGFloat = 12,
    guideColour: Color = .orange
  ) {
    self.pointSize = pointSize
    self.stroke = stroke
    self.node = node
    self.controlPoint = controlPoint
    self.labelFontSize = labelFontSize
    self.guideColour = guideColour
  }
}

public enum PointShape {
  case circle
  case square
}

public enum PointSize: CGFloat {
  case mini = 2
  case small = 4
  case normal = 6
  case large = 10
  case huge = 14
}

public struct PathStyle {
  public let fill: Color
  public let stroke: Color
  public let linewidth: CGFloat
  
  public init(
    fill: Color = .brown,
    stroke: Color = .blue,
    linewidth: CGFloat = 1
  ) {
    self.fill = fill
    self.stroke = stroke
    self.linewidth = linewidth
  }
}
