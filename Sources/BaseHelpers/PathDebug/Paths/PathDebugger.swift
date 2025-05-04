//
//  PathDebugger.swift
//  Components
//
//  Created by Dave Coleman on 30/9/2024.
//

import SwiftUI

public struct PathDebugger<T: Shape> {
  public let shape: T
  public let config: PathDebugConfig

  public func debugPaths(in rect: CGRect) -> DebugPaths {
    let originalPath = shape.path(in: rect)
    let paths: DebugPaths = PathAnalyser.analyse(originalPath, config: config)
    return paths
  }
}

enum CanvasPathDebugger {
  static func render(
    into context: GraphicsContext,
    size: CGSize,
    path: Path,
    config: PathDebugConfig = .init()
  ) {
    let debugPaths = PathAnalyser.analyse(path, config: config)
    
    context.stroke(debugPaths.original, with: .color(config.stroke.colour), lineWidth: config.stroke.width)
    context.stroke(debugPaths.connections, with: .color(config.controlPoint.guideColour), lineWidth: config.stroke.width)
    context.stroke(debugPaths.nodes, with: .color(config.node.colour), lineWidth: config.stroke.width)
    context.stroke(debugPaths.controlPoints, with: .color(config.controlPoint.colour), lineWidth: config.stroke.width)
  }
}

public struct ShapeDebugger<S: Shape>: View {

  public let debugger: PathDebugger<S>
  public let fill: Color
  public let shape: S

  public init(
    fill: Color = .blue.opacity(0.3),
    config: PathDebugConfig = .init(),
    @ViewBuilder shape: @escaping () -> S
  ) {
    self.fill = fill
    self.debugger = PathDebugger(shape: shape(), config: config)
    self.shape = shape()
  }

  public var body: some View {
    shape
      .fill(fill)
      .overlay(
        GeometryReader { geometry in
          let paths = debugger.debugPaths(in: geometry.frame(in: .local))
          ZStack {
            paths.original.stroke(debugger.config.stroke.colour, lineWidth: debugger.config.stroke.width)

            paths.connections.stroke(debugger.config.controlPoint.guideColour, lineWidth: debugger.config.stroke.width)

            // Default nodes
            paths.nodes.stroke(debugger.config.node.colour, lineWidth: debugger.config.stroke.width)


            // Default control points
            paths.controlPoints.stroke(debugger.config.controlPoint.colour, lineWidth: debugger.config.stroke.width)


          }  // END zstack
        }  // END geo reader
      )

  }
}
