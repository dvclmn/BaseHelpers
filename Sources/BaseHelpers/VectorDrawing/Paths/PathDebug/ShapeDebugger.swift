//
//  ShapeDebugger.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/7/2025.
//

import SwiftUI

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
            paths.original.stroke(
              debugger.config.stroke.colour,
              lineWidth: debugger.config.stroke.width
            )
            
            paths.connections.stroke(
              debugger.config.controlPoint.guideColour,
              lineWidth: debugger.config.stroke.width
            )
            
            // Default nodes
            paths.nodes.stroke(
              debugger.config.node.colour,
              lineWidth: debugger.config.stroke.width
            )
            
            
            // Default control points
            paths.controlPoints.stroke(
              debugger.config.controlPoint.colour,
              lineWidth: debugger.config.stroke.width
            )
            
            
          }  // END zstack
        }  // END geo reader
      )
    
  }
}
