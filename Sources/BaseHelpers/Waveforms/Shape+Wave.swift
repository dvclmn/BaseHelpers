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
  
  

  public init(
    wave: Wave,
    elapsed: CGFloat,
    sampleCount: Int,
    shouldOffsetPhase: Bool
  ) {
    self.wave = wave
    self.elapsed = elapsed
    self.sampleCount = sampleCount
    self.shouldOffsetPhase = shouldOffsetPhase
  }

  public func path(in rect: CGRect) -> Path {
    var p = Path()
    guard rect.width > 1, sampleCount > 1 else { return p }

    let step = rect.width / CGFloat(sampleCount - 1)

    var x = rect.minX
    var first = true
    var lastPoint: CGPoint?

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
//        p.addLine(to: point)
        if lastPoint == nil {
          lastPoint = point
        }
        
        if let last = lastPoint {
          p.addLine(to: last)
        } 
//        p.addCurve(
//          to: point,
//          control1: point.shifted(dx: waveY * 0.4 * x, dy: waveY),
//          control2: point.shifted(
//            dx: -6,
//            dy: -90
//          )
//        )
        
        /// This looks really cool
//        p.addQuadCurve(to: point, control: .zero)
//        p.addDot(at: point, radius: 16, using: .controlBezier)
      }
      x += step
    }
    return p
  }
}

//public struct WaveShape: Shape {
//  let phase: CGFloat  // temporal phase (radians)
//  let amplitude: CGFloat  // px
//  let cyclesAcross: CGFloat  // cycles across rect.width
//  let sampleCount: Int
//
//  public init(
//    phase: CGFloat,
//    amplitude: CGFloat,
//    cyclesAcross: CGFloat,
//    sampleCount: Int,
//  ) {
//    self.phase = phase
//    self.amplitude = amplitude
//    self.cyclesAcross = cyclesAcross
//    self.sampleCount = sampleCount
//  }
//
//  public func path(in rect: CGRect) -> Path {
//    var p = Path()
//    guard rect.width > 1, sampleCount > 1 else { return p }
//
//    let midY = rect.midY
//    let kx = (2 * .pi * cyclesAcross) / rect.width
//    let step = rect.width / CGFloat(sampleCount - 1)
//
//    var x: CGFloat = rect.minX
//    var first = true
//    for _ in 0..<sampleCount {
//      let y = midY + amplitude * sin(phase + kx * (x - rect.minX))
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

//public struct WaveShape<T: WaveRenderer>: Shape {
//  var engine: T
////  var engine: WaveEngine
//  var sampleCount: Int
//
//  public init(
//    engine: any WaveRenderer,
//    sampleCount: Int
//  ){
//    self.engine = engine
//    self.sampleCount = sampleCount
//  }
//
//  public func path(in rect: CGRect) -> Path {
//
//    var path = Path()
//
//    guard rect.width > 1, sampleCount > 1 else { return path }
//
//    let midY = rect.midY
//    let step = rect.width / CGFloat(sampleCount - 1)
//    var x: CGFloat = rect.minX
//    var first = true
//
//    for i in 0..<sampleCount {
//      let normalizedPosition = CGFloat(i) / CGFloat(sampleCount - 1)
//      let waveValue = renderer.evaluateWave(at: normalizedPosition)
//      let y = midY + waveValue
//
//      if first {
//        path.move(to: CGPoint(x: x, y: y))
//        first = false
//      } else {
//        path.addLine(to: CGPoint(x: x, y: y))
//      }
//      x += step
//    }
//
//    return path
////    return Path.generateWaveform(
////      in: rect,
////      sampleCount: sampleCount,
////      renderer: engine
////    )
//  }
//}
