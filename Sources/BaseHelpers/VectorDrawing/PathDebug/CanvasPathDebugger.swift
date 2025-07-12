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
      with: .color(config.stroke.colour),
      lineWidth: config.stroke.width
    )
    self.stroke(
      debugPaths.connections,
      with: .color(config.guideColour),
      lineWidth: config.stroke.width
    )
    self.stroke(
      debugPaths.nodes,
      with: .color(config.node.colour),
      lineWidth: config.stroke.width
    )
    self.stroke(
      debugPaths.controlPoints,
      with: .color(config.controlPoint.colour),
      lineWidth: config.stroke.width
    )
  }
}
