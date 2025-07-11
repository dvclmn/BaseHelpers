//
//  Debug+GraphicsContext.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/7/2025.
//

import SwiftUI

extension GraphicsContext {

  // MARK: - Path Debug
  public func debugPath(
    path: Path,
    config: PathDebugConfig = .init()
  ) {

    let debugResult = path.analyse()

    /// Draw original path
    self.stroke(
      debugResult.original,
      with: .color(config.pathStyle.strokeColour),
      lineWidth: config.pathStyle.linewidth)

    /// Draw debug elements
    for (element, path) in debugResult.debugPaths {
      self.fill(path, with: .color(element.displayColour))
    }

    /// Draw connections
    self.stroke(
      debugResult.connections,
      with: .color(config.guideColour),
      lineWidth: config.pathStyle.linewidth * 0.5)

    //    let analyser = PathAnalyser.analyse(path)
    //
    //    self.stroke(
    //      analyser.original,
    //      with: .color(config.pathStyle.strokeColour),
    //      lineWidth: config.pathStyle.linewidth
    //    )
    //    self.stroke(
    //      analyser.connections,
    //      with: .color(config.guideColour),
    //      lineWidth: config.pathStyle.linewidth
    //    )
    //    self.stroke(
    //      analyser.nodes,
    //      with: .color(config.nodeStyle.colour),
    //      lineWidth: config.pathStyle.linewidth
    //    )
    //    self.stroke(
    //      analyser.controlPoints,
    //      with: .color(config.controlPointStyle.colour),
    //      lineWidth: config.pathStyle.linewidth
    //    )
  }
}
