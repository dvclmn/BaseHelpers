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
  @ObservationIgnored
  private(set) var phase: CGFloat = 0

  /// Tuning: smaller = snappier, larger = smoother. (seconds)
  public var smoothingTimeConstant: CGFloat = 0.12

  /// Internal timekeeping
  @ObservationIgnored
  private var lastTime: CFTimeInterval?

  public init() {}

}

extension WaveEngine {

  public func value<T>(for property: WaveDrivenProperty<T>) -> T {
    property.evaluate(with: self.value)  // self.value = canonical wave output
  }

  //  public func drive<T>(_ driven: WaveDriven<T>) -> T {
  //    switch driven {
  //      case .linear(let multiplier, let offset, let transform):
  //        let raw = value * multiplier + offset
  //        return transform(raw)
  //    }
  //  }

  public var value: CGFloat {
    let base = sin(phase * properties.displayedCyclesAcross)
    let noisy = base + (properties.displayedNoise * randomNoise())
    return properties.displayedAmplitude * noisy
  }

  private func randomNoise() -> CGFloat {
    .random(in: -1...1)
  }

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

    if dt > 0 {
      let alphaValue = 1 - exp(-dt / max(0.0001, smoothingTimeConstant))
      for prop in WaveProperty.allCases {
        properties.updateProperty(
          prop,
          with: .alpha(alphaValue)
        )
      }
    } else {
      /// First frame: snap
      for prop in WaveProperty.allCases {
        properties.updateProperty(prop, with: .snap)
      }
    }

    /// Update phase
    phase += twoPi * properties.displayedFrequency * dt
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
