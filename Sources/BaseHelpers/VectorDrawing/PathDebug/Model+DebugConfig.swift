//
//  Model+DebugConfig.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/7/2025.
//

import SwiftUI

public struct PathDebugConfig {

  public let pathStyle: PathStyle
  public let labelFontSize: CGFloat
  public let guideColour: Color

  public init(
    pathStyle: PathStyle = .init(),
    labelFontSize: CGFloat = 11,
    guideColour: Color = .orange
  ) {
    self.pathStyle = pathStyle
    self.labelFontSize = labelFontSize
    self.guideColour = guideColour
  }
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

