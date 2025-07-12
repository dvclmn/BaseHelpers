//
//  Debug+GraphicsContext.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/7/2025.
//

import SwiftUI

extension GraphicsContext {

  public func debugPath(
    path: Path,
    config: PathDebugConfig = .init()
  ) {
    let result = path.analyse()
    PathDebugRenderer(result: result, config: config).draw(in: self)
  }


//  // MARK: - Path Debug
//  public func debugPath(
//    path: Path,
//    config: PathDebugConfig = .init()
//  ) {
//
//    let debugResult = path.analyse()
//
//    /// Draw original path
//    self.stroke(
//      debugResult.original,
//      with: .color(config.pathStyle.strokeColour),
//      lineWidth: config.pathStyle.linewidth)
//
//    /// Draw debug elements
//    for (element, path) in debugResult.debugPaths {
//      self.fill(path, with: .color(element.displayColour))
//
//      if element == .connection {
//        self.stroke(
//          /// Draw connections
//          debugResult.connections,
//          with: .color(element.displayColour),
//          lineWidth: config.pathStyle.linewidth)
//      }
//    }
//
//  }
}
