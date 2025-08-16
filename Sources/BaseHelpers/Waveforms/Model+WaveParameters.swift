//
//  Model+WaveParameter.swift
//  AnimationVisualiser
//
//  Created by Dave Coleman on 4/11/2024.
//

import Foundation

/// Note: at first glance (to me) it seemed redundant having both
/// `struct WaveParameters` *and* `enum WaveParameter`.
///
/// However a solid case can be made for keeping both.
///
/// `WaveParameters` Manages the state and current values of the wave parameters.
///
/// `WaveParameter` Encapsulates metadata, behaviors, and related properties
/// for each parameter.
///

enum WaveProperty: CaseIterable, Identifiable {

  /// How visually apparent is the oscillation effect. Aka strength
  case amplitude

  /// How rapidly does the oscillation occur. Aka speed
  case frequency

  /// When in time is the 'start point' located (can help to offset against other effects)
  case phase

  case baseline

  case cyclesAcross

  /// How much irregularity is introduced into the overall wave / movement
  case noise

//  static var activeParameters: [WaveParameter] {
//    [.amplitude, .frequency, .phase]
//  }

  var id: String {
    self.name.abbreviated
  }

  var name: (full: String, abbreviated: String) {
    switch self {
      case .amplitude: ("Amplitude", "Amp")
      case .frequency: ("Frequency", "Freq")
      case .cyclesAcross: ("Cycles Across", "Cycles")
      case .baseline: ("Baseline", "Base")
      case .phase: ("Phase", "Phase")
      case .noise: ("Noise", "Noise")
    }
  }

  var defaultValue: Double {
    switch self {
      case .amplitude: 1.0
      case .frequency: 1.0
      case .phase: 0.0
      case .baseline: 0.0
      case .cyclesAcross: 2.0
    }
  }

  var icon: String {
    switch self {
      case .amplitude: return "cellularbars"  // lines.measurement.horizontal, speaker.wave.2
      case .frequency: return "waveform.path.ecg"
      case .phase: return "point.forward.to.point.capsulepath"
      case .noise: return "dice"  // glowplug, scribble
    }
  }

  var keyPath: WritableKeyPath<WaveConfiguration, Double> {
    switch self {
      case .amplitude: \.amplitude
      case .frequency: \.frequency
      case .phase: \.phase
      case .noise: \.noise.finalValue
    }
  }

  var range: ClosedRange<Double> {
    switch self {
      case .amplitude: 0.01...5
      case .frequency: 0.01...20
      case .baseline: -1.0...1.0
      case .cyclesAcross: 0.1...10.0
      case .phase: 0...2 * Double.pi
      case .noise: 0...4
    }
  }

  //  var unitOfMeasurement: ValueUnits {
  //    switch self {
  //        /// Typically 0.0-1.0
  //      case .amplitude: .normalised
  //
  //        /// Cycles per second
  //      case .frequency: .hertz
  //
  //        /// Angular position in wave cycle
  //      case .phase: .radians
  //
  //        /// Noise magnitude typically `0.0-1.0`
  //      case .noise: .normalised
  //    }
  //  }
}
