//
//  DebugPathRenderer.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/7/2025.
//

import SwiftUI

public struct PathDebugRenderer {
  let result: PathDebugResult
  let config: PathDebugConfig

  public func draw(in context: GraphicsContext) {
    context.stroke(
      result.original,
      with: .color(config.pathStyle.strokeColour),
      lineWidth: config.pathStyle.linewidth)

    for (element, path) in result.debugPaths {
      
      let pathPoint = path.currentPoint
      context.fill(path, with: .color(element.displayColour))

      if element == .connection {
        context.stroke(
          result.connections,
          with: .color(element.displayColour),
          lineWidth: config.pathStyle.linewidth)
      }
    }
  }

  @ViewBuilder
  public func shapeView() -> some View {
    ZStack {
      /// Original path
      result.original
        .stroke(config.pathStyle.strokeColour, lineWidth: config.pathStyle.linewidth)

      /// Connection lines
      result.connections
        .stroke(DebugPathElement.connection.displayColour, lineWidth: config.pathStyle.linewidth)

      /// Control points
      result.controlPoints
        .fill(DebugPathElement.controlBezier.displayColour)

      /// Node points
      result.nodes
        .fill(DebugPathElement.nodeLine.displayColour)
    }
  }
}

extension GraphicsContext {

  public func debugPath(
    path: Path,
    config: PathDebugConfig = .init()
  ) {
    let result = path.analyse()
    PathDebugRenderer(result: result, config: config).draw(in: self)
  }

}
