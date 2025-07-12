//
//  CanvasPathDebugger.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/5/2025.
//

import SwiftUI

extension GraphicsContext {

  // MARK: - Path Debug
  public func debugPath(
    path: Path,
    config: PathDebugConfig = .init()
  ) {
    let debugPaths = PathAnalyser.analyse(path, config: config)

    self.stroke(
      debugPaths.original,
      with: .color(config.pathStyle.strokeColour),
      lineWidth: config.pathStyle.linewidth
    )
    self.stroke(
      debugPaths.connections,
      with: .color(config.guideColour),
      lineWidth: config.pathStyle.linewidth
    )
    self.stroke(
      debugPaths.nodes,
      with: .color(config.nodeStyle.colour),
      lineWidth: config.pathStyle.linewidth
    )
    self.stroke(
      debugPaths.controlPoints,
      with: .color(config.controlPointStyle.colour),
      lineWidth: config.pathStyle.linewidth
    )
  }
}
