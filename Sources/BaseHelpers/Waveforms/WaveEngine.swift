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
//@MainActor
//@Observable
public struct WaveEngine: Sendable, WaveRenderer {
  //public final class WaveEngine: WaveRenderer {

  var isPaused: Bool = false
  public var properties = WaveProperties()

  /// Phase accumulator (radians)
  //  @ObservationIgnored
  private(set) var phase: CGFloat = 0

  /// Internal timekeeping
  //  @ObservationIgnored
  //  private var lastTime: CFTimeInterval?
  private var lastWallClock: CFTimeInterval?
  private var accumulatedPlayTime: CFTimeInterval = 0

  public var isSmoothingActive: Bool = true
  /// Tuning: smaller = snappier, larger = smoother. (seconds)
  public var smoothingTimeConstant: CGFloat = 0.12

  public init() {}
}

extension WaveEngine {

  public var waveValue: CGFloat {
    let base = sin(phase + properties.engine.displayedPhaseOffset)
    let noisy = base + (properties.engine.displayedNoise * randomNoise())
    return properties.engine.displayedAmplitude * noisy
  }

  /// Evaluates the wave at a given position
  /// - Parameter position: Normalized position (0.0 to 1.0 across the wave)
  /// - Returns: Wave amplitude at that position
  public func evaluateWave(at position: CGFloat) -> CGFloat {
    let phaseAtPosition =
      phase + properties.engine.displayedPhaseOffset + (2 * .pi * properties.shape.displayedCyclesAcross * position)

    var waveValue = sin(phaseAtPosition)

    /// Apply noise if present
    if properties.engine.displayedNoise > 0 {
      let noiseValue = randomNoise()
      waveValue += noiseValue * properties.engine.displayedNoise
    }

    return properties.engine.displayedAmplitude * waveValue
  }

  public mutating func setEngineProperty(
    _ property: WaveEngineProperty,
    to value: CGFloat
  ) {
    self.properties.engine[keyPath: property.targetKeyPath] = value
  }

  public mutating func tick(now: CFTimeInterval) {

    if isPaused {
      // Don't advance phase or accumulated time
      lastWallClock = now
      return
    }

    guard let lastWallClock else {
      self.lastWallClock = now
      return
    }

    /// Advance accumulated play time
    let dt = now - lastWallClock
    accumulatedPlayTime += dt
    self.lastWallClock = now

    let smoothing = isSmoothingActive ? smoothingTimeConstant : 0
    /// Update properties relative to `dt`
    for prop in WaveEngineProperty.allCases {
      properties.engine.updateProperty(
        prop,
        dt: CGFloat(dt),
        timeConstant: smoothing
      )
    }
    for prop in WaveShapeProperty.allCases {
      properties.shape.updateProperty(
        prop,
        dt: CGFloat(dt),
        timeConstant: smoothing
      )
    }

    /// Advance phase relative to `dt`
    phase += twoPi * properties.engine.displayedFrequency * dt
    phase = wrapPhase(phase)
  }

  private func randomNoise(_ phaseAtPosition: CGFloat = 0) -> CGFloat {
    sin(phaseAtPosition * 7.3) * 0.3 + cos(phaseAtPosition * 13.7) * 0.2
    //    .random(in: -1...1)
  }

  /// Angle helper
  private func wrapPhase(_ phase: CGFloat) -> CGFloat {
    var r = phase.truncatingRemainder(dividingBy: twoPi)
    if r < 0 { r += twoPi }  // keep in [0, 2π)
    return r
  }
}

extension WaveEngine {

}
