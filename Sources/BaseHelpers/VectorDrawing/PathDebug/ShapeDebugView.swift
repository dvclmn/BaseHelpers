//
//  ShapeDebug.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/7/2025.
//

import SwiftUI

public struct ShapeDebug<S: Shape>: View {

  public let shape: S
  public let config: PathDebugConfig

  public init(
    config: PathDebugConfig = .init(),
    @ViewBuilder shape: @escaping () -> S
  ) {
    self.config = config
    self.shape = shape()
  }

  public var body: some View {
    shape
      .fill(config.pathStyle.fillColour)
      .overlay {
        GeometryReader { proxy in
          let rect = proxy.frame(in: .local)
          let debugResult = shape.path(in: rect).analyse()

          ZStack {
            /// Original path
            debugResult.original
              .stroke(
                config.pathStyle.strokeColour,
                lineWidth: config.pathStyle.linewidth)

            /// Connection lines
            debugResult.connections
              .stroke(
                config.guideColour,
                lineWidth: config.pathStyle.linewidth * 0.5)

            /// Control points
            debugResult.controlPoints
              .fill(DebugPathElement.controlBezier.displayColour)

            /// Node points
            debugResult.nodes
              .fill(DebugPathElement.nodeLine.displayColour)
          }
        }
      }
  }
}
