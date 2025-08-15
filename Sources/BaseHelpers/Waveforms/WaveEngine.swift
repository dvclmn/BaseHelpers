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
//@Observable
//final public class WaveEngine {
public struct WaveEngine {
  
  var isPaused: Bool = false
  
  /// Public, user-controlled targets
  /// Hz (temporal)
  var targetFrequency: CGFloat = 1.2

  /// px
  var targetAmplitude: CGFloat = 40

  /// px vertical offset
  var targetBaseline: CGFloat = 0

  /// cycles across view width (spatial)
  var targetCyclesAcross: CGFloat = 1.5

  /// Smoothed/displayed values (what the renderer uses)
  private(set) var displayedFrequency: CGFloat = 1.2
  private(set) var displayedAmplitude: CGFloat = 40
  private(set) var displayedBaseline: CGFloat = 0
  private(set) var displayedCyclesAcross: CGFloat = 1.5

  /// Phase accumulator (radians)
//  @ObservationIgnored
  private(set) var phase: CGFloat = 0

  /// Tuning: smaller = snappier, larger = smoother. (seconds)
//  @ObservationIgnored
  var smoothingTimeConstant: CGFloat = 0.12

  /// Internal timekeeping
  @ObservationIgnored
  private var lastTime: CFTimeInterval?
  
  public init() {}

}

extension WaveEngine {
  
  public mutating func tick(now: CFTimeInterval) {
    // Compute dt
    let dt: CGFloat
    if let last = lastTime { dt = max(0, CGFloat(now - last)) } else { dt = 0; }
    lastTime = now
    
    // 1) Exponential smoothing for parameters
    //    displayed += (target - displayed) * (1 - e^{-dt/τ})
    if dt > 0 {
      let alpha = 1 - exp(-dt / max(0.0001, smoothingTimeConstant))
      displayedFrequency += (targetFrequency     - displayedFrequency) * alpha
      displayedAmplitude += (targetAmplitude     - displayedAmplitude) * alpha
      displayedBaseline  += (targetBaseline      - displayedBaseline)  * alpha
      displayedCyclesAcross += (targetCyclesAcross - displayedCyclesAcross) * alpha
    } else {
      // First frame: snap
      displayedFrequency = targetFrequency
      displayedAmplitude = targetAmplitude
      displayedBaseline  = targetBaseline
      displayedCyclesAcross = targetCyclesAcross
    }
    
    // 2) Integrate phase for continuity (φ += 2π f dt)
    phase += twoPi * displayedFrequency * dt
    // keep φ in a safe range to avoid float blow-up
    phase = wrapPhase(phase)
  }
  
  /// Angle helper
  private func wrapPhase(_ phase: CGFloat) -> CGFloat {
    var r = phase.truncatingRemainder(dividingBy: twoPi)
    if r < 0 { r += twoPi } // keep in [0, 2π)
    return r
  }
}
