//
//  Handler+Waveform.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/8/2025.
//

import SwiftUI

public struct WaveProperties: Sendable, Equatable {
  
  /// Public, user-controlled targets (bind these to sliders)
  public var targetAmplitude: CGFloat = WaveProperty.amplitude.defaultValue
  public var targetFrequency: CGFloat = WaveProperty.frequency.defaultValue
  public var targetCyclesAcross: CGFloat = WaveProperty.cyclesAcross.defaultValue
  public var targetNoise: CGFloat = WaveProperty.noise.defaultValue
  
  /// Smoothed/displayed values (what the renderer uses)
  public var displayedAmplitude: CGFloat = .zero
  public var displayedFrequency: CGFloat = .zero
  public var displayedCyclesAcross: CGFloat = .zero
  public var displayedNoise: CGFloat = .zero
  
  public init() {}
}

// MARK: - WaveEngine
/// Drives a phase-continuous waveform with parameter smoothing.
/// - Integrates phase using `displayedFrequency` so phase never resets.
/// - Smooths parameter changes (frequency, amplitude, vertical offset) with a time constant.
@MainActor
@Observable
public final class WaveEngine {
  //public struct WaveEngine {

  var isPaused: Bool = false

  var properties = WaveProperties()

  /// Phase accumulator (radians)
  @ObservationIgnored
  private(set) var phase: CGFloat = 0

  /// Tuning: smaller = snappier, larger = smoother. (seconds)
  public var smoothingTimeConstant: CGFloat = 0.12

  /// Internal timekeeping
  @ObservationIgnored
  private var lastTime: CFTimeInterval?

  public init() {

  }

}

extension WaveEngine {
  
  public func propertyBinding(_ property: WaveProperty) -> Binding<CGFloat> {
    return Binding<CGFloat> {
      self.properties[keyPath: property.targetKeyPath]
    } set: { newValue in
      self.setProperty(property, to: newValue)
    }
  }
  
  public func setProperty(
    _ property: WaveProperty,
    to value: CGFloat
  ) {
    self.properties[keyPath: property.targetKeyPath] = value
  }

  public var smoothingBinding: Binding<CGFloat> {
    return Binding {
      self.smoothingTimeConstant
    } set: { newValue in
      self.smoothingTimeConstant = max(0.016, newValue)
    }
  }

  public func tick(now: CFTimeInterval) {
    let dt = computeDeltaTime(now)
    lastTime = now

    if dt > 0 {
      let alpha = 1 - exp(-dt / max(0.0001, smoothingTimeConstant))
      for prop in WaveProperty.allCases {
        computePropertyThing(prop, alpha: alpha)
      }
//      displayedFrequency += (targetFrequency - displayedFrequency) * alpha
//      displayedAmplitude += (targetAmplitude - displayedAmplitude) * alpha
//      displayedCyclesAcross += (targetCyclesAcross - displayedCyclesAcross) * alpha
//      displayedNoise += (targetNoise - displayedNoise) * alpha
    } else {
      // First frame: snap
      for prop in WaveProperty.allCases {
        computeSnap(prop)
//        computePropertyThing(prop, alpha: alpha)
      }
//      displayedFrequency = targetFrequency
//      displayedAmplitude = targetAmplitude
//      displayedCyclesAcross = targetCyclesAcross
//      displayedNoise = targetNoise
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
    phase += twoPi * properties.displayedFrequency * dt
    phase = wrapPhase(phase)
  }
  
  private func computePropertyThing(_ property: WaveProperty, alpha: CGFloat) {
    let delta = self.properties[keyPath: property.targetKeyPath] - self.properties[keyPath: property.displayedKeyPath]
    self.properties[keyPath: property.displayedKeyPath] += delta * alpha
  }
  
  private func computeSnap(_ property: WaveProperty) {
    self.properties[keyPath: property.displayedKeyPath] = self.properties[keyPath: property.targetKeyPath]
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
