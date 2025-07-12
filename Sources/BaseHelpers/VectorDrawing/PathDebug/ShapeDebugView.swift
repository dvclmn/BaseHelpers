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
      .fill(config.pathStyle.fillColour.lowOpacity)
      .overlay {
        GeometryReader { proxy in
          
//          let paths =
////          let paths = debugPaths(in: proxy.frame(in: .local))
//
//          for path
//          
//          paths.original.stroke(
//            config.pathStyle.strokeColour,
//            lineWidth: config.pathStyle.linewidth
//          )
//
//          paths.connections.stroke(
//            config.guideColour,
//            lineWidth: config.pathStyle.linewidth
//          )
//
//          paths.nodes.stroke(
//            config.nodeStyle.colour,
//            lineWidth: config.pathStyle.linewidth
//          )
//
//          paths.controlPoints.stroke(
//            config.controlPointStyle.colour,
//            lineWidth: config.pathStyle.linewidth
//          )

        }  // END geo reader
      }  // END overlay
  }
}
extension ShapeDebug {
//  private func debugPaths(in rect: CGRect) -> DebugPaths {
//    let originalPath = shape.path(in: rect)
////    let paths: DebugPaths = PathAnalyser.analyse(originalPath, config: config)
////    let paths: [DebugPath] = PathAnalyser.analyse(originalPath, config: config)
//    return paths
//  }
}
