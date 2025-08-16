//
//  Handler+Waveform.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/8/2025.
//

import SwiftUI

// MARK: - WaveEngine
/// Drives a phase-continuous waveform with parameter smoothing.
/// - Integrates phase using `displayedFrequency` so phase never resets.
/// - Smooths parameter changes (frequency, amplitude, vertical offset) with a time constant.
@MainActor
public struct WaveEngine {

  var isPaused: Bool = false

  // Stored values
  var targetFrequency: CGFloat = 1.0
  var displayedFrequency: CGFloat = 1.0

  var targetAmplitude: CGFloat = 1.0
  var displayedAmplitude: CGFloat = 1.0

  var targetBaseline: CGFloat = 0.0
  var displayedBaseline: CGFloat = 0.0

  var targetCyclesAcross: CGFloat = 2.0
  var displayedCyclesAcross: CGFloat = 2.0

  var targetNoise: CGFloat = 2.0
  var displayedNoise: CGFloat = 2.0

  //  /// Hz (temporal)
  //  var targetFrequency: CGFloat = 1.2
  //
  //  /// px
  //  var targetAmplitude: CGFloat = 40
  //
  //  /// px vertical offset
  //  var targetBaseline: CGFloat = 0
  //
  //  /// cycles across view width (spatial)
  //  var targetCyclesAcross: CGFloat = 1.5

  //  /// Smoothed/displayed values (what the renderer uses)
  //  private(set) var displayedFrequency: CGFloat = 1.2
  //  private(set) var displayedAmplitude: CGFloat = 40
  //  private(set) var displayedBaseline: CGFloat = 0
  //  private(set) var displayedCyclesAcross: CGFloat = 1.5
  //
  //  var target: [WaveProperty: CGFloat] = [:]
  //  var displayed: [WaveProperty: CGFloat] = [:]

  /// Phase accumulator (radians)
  //  @ObservationIgnored
  private(set) var phase: CGFloat = 0

  /// Tuning: smaller = snappier, larger = smoother. (seconds)
  //  @ObservationIgnored
  var smoothingTimeConstant: CGFloat = 0.12

  /// Internal timekeeping
  @ObservationIgnored
  private var lastTime: CFTimeInterval?

  //  public init() {}
  public init() {
//    for property in WaveProperty.allCases {
//      target[property] = property.defaultValue
//      displayed[property] = property.defaultValue
//    }
  }

}

extension WaveEngine {

  mutating func tick(now: CFTimeInterval) {
    let dt = computeDeltaTime(now)
    lastTime = now

    if dt > 0 {
      for property in WaveProperty.allCases {
        self[keyPath: property.displayedKeyPath] =
          self[keyPath: property.displayedKeyPath].smoothed(
            towards: self[keyPath: property.targetKeyPath],
            dt: dt,
            timeConstant: smoothingTimeConstant
          )
      }
    } else {
      // First frame: snap everything
      for property in WaveProperty.allCases {
        self[keyPath: property.displayedKeyPath] =
          self[keyPath: property.targetKeyPath]
      }
    }

    /// Update phase
    phase += twoPi * displayedFrequency * dt
    phase = wrapPhase(phase)
  }

  //  public mutating func tick(now: CFTimeInterval) {
  //    let dt = computeDeltaTime(now)
  //    lastTime = now
  //
  //    if dt > 0 {
  //      for property in WaveProperty.allCases {
  //        displayed[property] = displayed[property]!.smoothed(
  //          towards: target[property]!,
  //          dt: dt,
  //          timeConstant: smoothingTimeConstant
  //        )
  //      }
  //    } else {
  //      // First frame: snap
  //      displayed = target
  //    }
  //
  //    // You’d still update your phase here
  //    if let freq = displayed[.frequency] {
  //      phase += twoPi * freq * dt
  //      phase = wrapPhase(phase)
  //    }
  //  }

  //  public mutating func tick(now: CFTimeInterval) {
  //    let dt = computeDeltaTime(now)
  //    lastTime = now
  //
  //    if dt > 0 {
  //      displayedFrequency = displayedFrequency.smoothed(
  //        towards: targetFrequency, dt: dt, timeConstant: smoothingTimeConstant)
  //      displayedAmplitude = displayedAmplitude.smoothed(
  //        towards: targetAmplitude, dt: dt, timeConstant: smoothingTimeConstant)
  //      displayedBaseline = displayedBaseline.smoothed(
  //        towards: targetBaseline, dt: dt, timeConstant: smoothingTimeConstant)
  //      displayedCyclesAcross = displayedCyclesAcross.smoothed(
  //        towards: targetCyclesAcross, dt: dt, timeConstant: smoothingTimeConstant)
  //    } else {
  //      displayedFrequency = targetFrequency
  //      displayedAmplitude = targetAmplitude
  //      displayedBaseline = targetBaseline
  //      displayedCyclesAcross = targetCyclesAcross
  //    }
  //
  //    phase += twoPi * displayedFrequency * dt
  //    phase = wrapPhase(phase)
  //  }

  //  public mutating func tick(now: CFTimeInterval) {
  //
  //    let dt = computeDeltaTime(now)
  //    lastTime = now
  //
  //    /// 1) Exponential smoothing for parameters
  //    if dt > 0 {
  //      /// `alpha` is the per-tick smoothing factor that decides how much of the gap
  //      /// between the current value and the target value we close on this frame.
  //      ///
  //      /// Important: alpha helps make this smoothing time dependant,
  //      /// not frame-rate dependant
  //      let alpha = 1 - exp(-dt / max(0.0001, smoothingTimeConstant))
  //      displayedFrequency += (targetFrequency - displayedFrequency) * alpha
  //      displayedAmplitude += (targetAmplitude - displayedAmplitude) * alpha
  //      displayedBaseline += (targetBaseline - displayedBaseline) * alpha
  //      displayedCyclesAcross += (targetCyclesAcross - displayedCyclesAcross) * alpha
  //    } else {
  //      /// First frame: snap
  //      displayedFrequency = targetFrequency
  //      displayedAmplitude = targetAmplitude
  //      displayedBaseline = targetBaseline
  //      displayedCyclesAcross = targetCyclesAcross
  //    }
  //
  //    /// 2) Integrate phase for continuity (`phase += 2π f dt`)
  //    phase += twoPi * displayedFrequency * dt
  //    /// keep `phase` in a safe range to avoid float blow-up
  //    phase = wrapPhase(phase)
  //  }

  private func computeDeltaTime(_ now: CFTimeInterval) -> CGFloat {
    guard let lastTime else {
      return .zero
    }
    return max(0, CGFloat(now - lastTime))
  }

  /// Angle helper
  private func wrapPhase(_ phase: CGFloat) -> CGFloat {
    var r = phase.truncatingRemainder(dividingBy: twoPi)
    if r < 0 { r += twoPi }  // keep in [0, 2π)
    return r
  }
}
