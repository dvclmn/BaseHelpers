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
          let result = shape.path(in: rect).analyse()
          PathDebugRenderer(
            result: result,
            config: config,
            zoomPercent: nil
          ).shapeView()
        }
      }
  }
}
