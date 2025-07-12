//
//  Model+DebugConfig.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/7/2025.
//

import SwiftUI

public struct PathDebugConfig {
  
  public let pathStyle: PathStyle
  public let nodeStyle: PointStyle
  public let controlPointStyle: PointStyle
  public let labelFontSize: CGFloat
  public let guideColour: Color
  
  public init(
    pathStyle: PathStyle = .init(),
    nodeStyle: PointStyle = .init(),
    controlPointStyle: PointStyle = .init(),
    labelFontSize: CGFloat = 11,
    guideColour: Color = .orange
  ) {
    self.pathStyle = pathStyle
    self.nodeStyle = nodeStyle
    self.controlPointStyle = controlPointStyle
    self.labelFontSize = labelFontSize
    self.guideColour = guideColour
  }
}
extension PathDebugConfig {
  public func pointSize(for type: PointType) -> CGFloat {
    switch type {
      case .node:
        self.nodeStyle.size.rawValue
      case .control:
        self.controlPointStyle.size.rawValue
    }
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
  public let fillColour: Color
  public let strokeColour: Color
  public let linewidth: CGFloat
  
  public init(
    fillColour: Color = .brown,
    strokeColour: Color = .blue,
    linewidth: CGFloat = 1
  ) {
    self.fillColour = fillColour
    self.strokeColour = strokeColour
    self.linewidth = linewidth
  }
}

public struct DebugPaths {
  public let original: Path
  public let nodes: Path
  public let controlPoints: Path
  public let connections: Path
}
