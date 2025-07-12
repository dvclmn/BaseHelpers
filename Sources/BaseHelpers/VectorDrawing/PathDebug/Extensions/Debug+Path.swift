//
//  Debug+Path.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/7/2025.
//

import SwiftUI

extension Path {

  public func debugDraw(
    in context: GraphicsContext,
    rect: CGRect,
    config: PathDebugConfig = PathDebugConfig()
  ) {
    let debugResult = self.analyse()

    // Draw original path
    context.stroke(
      debugResult.original,
      with: .color(config.pathStyle.strokeColour),
      lineWidth: config.pathStyle.linewidth)

    // Draw debug elements
    for (element, path) in debugResult.debugPaths {
      context.fill(path, with: .color(element.displayColour))
    }

    // Draw connections
    context.stroke(
      debugResult.connections,
      with: .color(config.guideColour),
      lineWidth: config.pathStyle.linewidth * 0.5)
  }
}
