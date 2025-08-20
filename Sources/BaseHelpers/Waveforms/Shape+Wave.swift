//
//  WaveShape.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/8/2025.
//

import SwiftUI

public struct WaveShape: Shape {
  let wave: Wave
  let elapsed: CGFloat
  let sampleCount: Int
  let shouldOffsetPhase: Bool
  let isDotStyle: Bool

  public init(
    wave: Wave,
    elapsed: CGFloat,
    sampleCount: Int,
    shouldOffsetPhase: Bool,
    isDotStyle: Bool = false,
  ) {
    self.wave = wave
    self.elapsed = elapsed
    self.sampleCount = sampleCount
    self.shouldOffsetPhase = shouldOffsetPhase
    self.isDotStyle = isDotStyle
  }

  public func path(in rect: CGRect) -> Path {
    var p = Path()
    guard rect.width > 1, sampleCount > 1 else { return p }

    let step = rect.width / CGFloat(sampleCount - 1)

    var x = rect.minX
    var first = true

    for _ in 0..<sampleCount {
      let waveY = wave.valueAt(
        x: x,
        in: rect,
        elapsed: elapsed,
        shouldOffsetPhase: shouldOffsetPhase
      )
      let y = rect.midY + waveY

      let point = CGPoint(x: x, y: y)

      if first {
        p.move(to: point)
        first = false
      } else {
        if isDotStyle {
          p.addDot(at: point, radius: 5, using: .controlBezier)
        } else {
          p.addLine(to: point)
        }

        /// This looks really cool
        //        p.addQuadCurve(to: point, control: .zero)
        //        p.addDot(at: point, radius: 16, using: .controlBezier)
      }
      x += step
    }
    return p
  }
}
