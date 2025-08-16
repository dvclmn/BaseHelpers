//
//  WaveShape.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/8/2025.
//

import SwiftUI

struct WaveShape: Shape {
  /// temporal phase (radians)
  var phase: CGFloat

  /// px
  var amplitude: CGFloat

  /// px
//  var baseline: CGFloat

  /// cycles across rect.width
  var cyclesAcross: CGFloat

  var sampleCount: Int = 600

  func path(in rect: CGRect) -> Path {
    var p = Path()
    guard rect.width > 1, sampleCount > 1 else { return p }

    let midY = rect.midY
//    let midY = rect.midY + baseline
    let kx = (2 * .pi * cyclesAcross) / rect.width
    let step = rect.width / CGFloat(sampleCount - 1)

    var x: CGFloat = rect.minX
    var first = true
    for _ in 0..<sampleCount {
      let y = midY + amplitude * sin(phase + kx * (x - rect.minX))
      if first {
        p.move(to: CGPoint(x: x, y: y))
        first = false
      } else {
        p.addLine(to: CGPoint(x: x, y: y))
      }
      x += step
    }
    return p
  }
}
