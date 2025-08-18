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

  var isPaused: Bool = false
  var properties = WaveProperties()

  /// Phase accumulator (radians)
  @ObservationIgnored private(set) var phase: CGFloat = 0

  /// Internal timekeeping
  @ObservationIgnored private var lastTime: CFTimeInterval?

  /// Tuning: smaller = snappier, larger = smoother. (seconds)
  public var smoothingTimeConstant: CGFloat = 0.12

  public init() {}
}

extension WaveEngine {

  public var value: CGFloat {
    let base = sin(phase + properties.engine.displayedPhaseOffset)
    let noisy = base + (properties.engine.displayedNoise * randomNoise())
    return properties.engine.displayedAmplitude * noisy
  }

  

  public func engineBinding(_ property: WaveEngineProperty) -> Binding<CGFloat> {
    return Binding<CGFloat> {
      self.properties.engine[keyPath: property.targetKeyPath]
    } set: { newValue in
      self.setEngineProperty(property, to: newValue)
    }
  }

  public func setEngineProperty(
    _ property: WaveEngineProperty,
    to value: CGFloat
  ) {
    self.properties.engine[keyPath: property.targetKeyPath] = value
  }

  public func smoothingBinding() -> Binding<CGFloat> {
    return Binding {
      self.smoothingTimeConstant
    } set: { newValue in
      self.smoothingTimeConstant = max(0.016, newValue)
    }
  }

  public func tick(now: CFTimeInterval) {
    let dt = computeDeltaTime(now)
    lastTime = now
    
    /// Update engine domain
    for prop in WaveEngineProperty.allCases {
      properties.engine.updateProperty(prop, dt: CGFloat(dt), timeConstant: smoothingTimeConstant)
    }
    
    /// Update shape domain
    for prop in WaveShapeProperty.allCases {
      properties.shape.updateProperty(prop, dt: CGFloat(dt), timeConstant: smoothingTimeConstant)
    }
    
    phase += twoPi * properties.engine.displayedFrequency * dt
    phase = wrapPhase(phase)
  }
  
  private func randomNoise() -> CGFloat {
    .random(in: -1...1)
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

extension WaveEngine {
  /// Evaluates the wave at a given position
  /// - Parameter position: Normalized position (0.0 to 1.0 across the wave)
  /// - Returns: Wave amplitude at that position
  public func evaluateWave(at position: CGFloat) -> CGFloat {
    let phaseAtPosition = phase +
    properties.engine.displayedPhaseOffset +
    (2 * .pi * properties.shape.displayedCyclesAcross * position)
    
    var waveValue = sin(phaseAtPosition)
    
    // Apply noise if present
    if properties.engine.displayedNoise > 0 {
      // You could use a noise function here, or simple random variation
      // This is a placeholder - replace with your actual noise implementation
      let noiseValue = sin(phaseAtPosition * 7.3) * 0.3 + cos(phaseAtPosition * 13.7) * 0.2
      waveValue += noiseValue * properties.engine.displayedNoise
    }
    
    return properties.engine.displayedAmplitude * waveValue
  }
}
