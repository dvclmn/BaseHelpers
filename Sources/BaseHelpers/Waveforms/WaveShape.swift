//
//  WaveShape.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/8/2025.
//

import SwiftUI

struct WaveShape: Shape {
  var engine: WaveEngine
  var sampleCount: Int
  
  func path(in rect: CGRect) -> Path {
    return engine.generatePath(in: rect, sampleCount: sampleCount)
  }
}

//struct WaveShape: Shape {
//
//  var properties: WaveProperties
//
//  /// temporal phase (radians)
//  var phase: CGFloat
//  var sampleCount: Int
//
//  func path(in rect: CGRect) -> Path {
//    var p = Path()
//    /// If the container rect isn't wide enough, or the sample count too low,
//    /// just return an empty Path
//    guard rect.width > 1, sampleCount > 1 else { return p }
//
//    let midY = rect.midY
//    let kx = (2 * .pi * properties.shape.displayedCyclesAcross) / rect.width
//    let step = rect.width / CGFloat(sampleCount - 1)
//
//    var x: CGFloat = rect.minX
//    var first = true
//    for _ in 0..<sampleCount {
//      let y = midY + properties.engine.displayedAmplitude * sin(phase + properties.engine.displayedPhaseOffset + kx * (x - rect.minX))
//      if first {
//        p.move(to: CGPoint(x: x, y: y))
//        first = false
//      } else {
//        p.addLine(to: CGPoint(x: x, y: y))
//      }
//      x += step
//    }
//    return p
//  }
//}
