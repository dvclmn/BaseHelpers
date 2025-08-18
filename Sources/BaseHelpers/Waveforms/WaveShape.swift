//
//  WaveShape.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/8/2025.
//

import SwiftUI

public protocol WaveRenderer {
  func evaluateWave(at position: CGFloat) -> CGFloat
}

public struct WaveShape: Shape {
  var engine: WaveEngine
  var sampleCount: Int
  
  public init(
    engine: WaveEngine,
    sampleCount: Int
  ){
    self.engine = engine
    self.sampleCount = sampleCount
  }

  public func path(in rect: CGRect) -> Path {
    return Path.generateWaveform(
      in: rect,
      sampleCount: sampleCount,
      renderer: engine
    )
  }
}
