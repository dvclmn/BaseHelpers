//
//  ShapeDebug.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/7/2025.
//

import SwiftUI

public struct ShapeDebug<S: Shape>: View {

  public let shape: S
  //  public let debugger: PathDebug<S>
  //  public let fill: Color
  public let config: PathDebugConfig

  public init(
    //    fill: Color = .blue.opacity(0.3),
    config: PathDebugConfig = .init(),
    @ViewBuilder shape: @escaping () -> S
  ) {
    //    self.fill = fill
    //    self.debugger = PathDebug(shape: shape(), config: config)
    self.config = config
    self.shape = shape()
  }

  public var body: some View {
    shape
      .fill(config.pathStyle.fillColour.lowOpacity)
      .overlay {
        GeometryReader { proxy in
          let paths = debugPaths(in: proxy.frame(in: .local))

          paths.original.stroke(
            config.pathStyle.strokeColour,
            lineWidth: config.pathStyle.linewidth
          )

          paths.connections.stroke(
            config.guideColour,
            lineWidth: config.pathStyle.linewidth
          )

          paths.nodes.stroke(
            config.nodeStyle.colour,
            lineWidth: config.pathStyle.linewidth
          )

          paths.controlPoints.stroke(
            config.controlPointStyle.colour,
            lineWidth: config.pathStyle.linewidth
          )

        }  // END geo reader
      }  // END overlay
  }
}
extension ShapeDebug {
  private func debugPaths(in rect: CGRect) -> DebugPaths {
    let originalPath = shape.path(in: rect)
    let paths: DebugPaths = PathAnalyser.analyse(originalPath, config: config)
    return paths
  }
}
