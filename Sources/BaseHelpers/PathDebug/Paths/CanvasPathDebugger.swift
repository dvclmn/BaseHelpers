//
//  CanvasPathDebugger.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/5/2025.
//

import SwiftUI

//public struct CanvasPathDebugger: View {
//  let pathBuilder: (CGSize) -> Path
//  let config: PathDebugConfig
//  let fill: Color
//  
//  public init(
//    fill: Color = .blue.opacity(0.3),
//    config: PathDebugConfig = .init(),
//    path: @escaping (CGSize) -> Path
//  ) {
//    self.fill = fill
//    self.config = config
//    self.pathBuilder = path
//  }
//  
//  public var body: some View {
//    Canvas { context, size in
//      let path = pathBuilder(size)
////      let debug = PathAnalyzer.analyze(path, config: config)
//      
//      let debugPaths = PathAnalyser.analyse(pathBuilder(size), config: config)
//      
//      context.fill(path, with: .color(fill))
//      context.stroke(debugPaths.original, with: .color(config.stroke.colour), lineWidth: config.stroke.width)
//      context.stroke(debugPaths.connections, with: .color(config.controlPoint.guideColour), lineWidth: config.stroke.width)
//      context.stroke(debugPaths.nodes, with: .color(config.node.colour), lineWidth: config.stroke.width)
//      context.stroke(debugPaths.controlPoints, with: .color(config.controlPoint.colour), lineWidth: config.stroke.width)
//    }
//  }
//}
