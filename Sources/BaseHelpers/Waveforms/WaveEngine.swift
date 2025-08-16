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
@Observable
public final class WaveEngine {
//public struct WaveEngine {

  var isPaused: Bool = false

  // Public, user-controlled targets (bind these to sliders)
  public var targetFrequency: CGFloat = 1.2      // Hz (temporal)
  public var targetAmplitude: CGFloat = 40        // px
  public var targetCyclesAcross: CGFloat = 1.5    // cycles across view width (spatial)
  
  // Smoothed/displayed values (what the renderer uses)
  private(set) var displayedFrequency: CGFloat = 1.2
  private(set) var displayedAmplitude: CGFloat = 40
  private(set) var displayedCyclesAcross: CGFloat = 1.5

  /// Phase accumulator (radians)
    @ObservationIgnored
  private(set) var phase: CGFloat = 0

  /// Tuning: smaller = snappier, larger = smoother. (seconds)
    @ObservationIgnored
  public var smoothingTimeConstant: CGFloat = 0.12

  /// Internal timekeeping
  @ObservationIgnored
  private var lastTime: CFTimeInterval?


  public init() {

  }

}

extension WaveEngine {

  public func tick(now: CFTimeInterval) {
    let dt = computeDeltaTime(now)
    lastTime = now

    if dt > 0 {
      let alpha = 1 - exp(-dt / max(0.0001, smoothingTimeConstant))
      displayedFrequency += (targetFrequency     - displayedFrequency) * alpha
      displayedAmplitude += (targetAmplitude     - displayedAmplitude) * alpha
//      displayedBaseline  += (targetBaseline      - displayedBaseline)  * alpha
      displayedCyclesAcross += (targetCyclesAcross - displayedCyclesAcross) * alpha
    } else {
      // First frame: snap
      displayedFrequency = targetFrequency
      displayedAmplitude = targetAmplitude
//      displayedBaseline  = targetBaseline
      displayedCyclesAcross = targetCyclesAcross
    }
    
//    if dt > 0 {
//      for property in WaveProperty.allCases {
//        self[keyPath: property.displayedKeyPath] =
//          self[keyPath: property.displayedKeyPath].smoothed(
//            towards: self[keyPath: property.targetKeyPath],
//            dt: dt,
//            timeConstant: smoothingTimeConstant
//          )
//      }
//    } else {
//      // First frame: snap everything
//      for property in WaveProperty.allCases {
//        self[keyPath: property.displayedKeyPath] =
//          self[keyPath: property.targetKeyPath]
//      }
//    }

    /// Update phase
    phase += twoPi * displayedFrequency * dt
    phase = wrapPhase(phase)
  }

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
