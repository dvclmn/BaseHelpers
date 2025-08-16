//
//  Model+WaveParameter.swift
//  AnimationVisualiser
//
//  Created by Dave Coleman on 4/11/2024.
//

import Foundation

public enum WaveProperty: CaseIterable, Identifiable {

  /// How visually apparent is the oscillation effect. Aka strength
  case amplitude

  /// How rapidly does the oscillation occur. Aka speed
  case frequency

  case cyclesAcross

  /// How much irregularity is introduced into the overall wave / movement
  case noise

  //  static var activeParameters: [WaveParameter] {
  //    [.amplitude, .frequency, .phase]
  //  }

  public var id: String {
    self.name.abbreviated
  }

  var name: (full: String, abbreviated: String) {
    switch self {
      case .amplitude: ("Amplitude", "Amp")
      case .frequency: ("Frequency", "Freq")
      case .cyclesAcross: ("Cycles Across", "Cycles")
      case .noise: ("Noise", "Noise")
    }
  }

  var defaultValue: Double {
    switch self {
      case .amplitude: 1.0
      case .frequency: 1.0
      case .cyclesAcross: 2.0
      case .noise: 0.0
    }
  }

  var icon: String {
    switch self {
      case .amplitude: "cellularbars"  // lines.measurement.horizontal, speaker.wave.2
      case .frequency: "waveform.path.ecg"
      //      case .phase: "point.forward.to.point.capsulepath"
      case .noise: "dice"  // glowplug, scribble
      case .cyclesAcross: "eye"
    }
  }

  //  var keyPath: WritableKeyPath<WaveConfiguration, Double> {
  //    switch self {
  //      case .amplitude: \.amplitude
  //      case .frequency: \.frequency
  //      case .phase: \.phase
  //      case .noise: \.noise.finalValue
  //    }
  //  }

  // Key paths for *displayed* values
  //  var displayedKeyPath: WritableKeyPath<WaveEngine, CGFloat> {
  //    switch self {
  //      case .frequency: \.displayedFrequency
  //      case .amplitude: \.displayedAmplitude
  //      case .baseline: \.displayedBaseline
  //      case .cyclesAcross: \.displayedCyclesAcross
  //      case .noise: \.displayedNoise
  //    }
  //  }
  //
  //  // Key paths for *target* values
  //  var targetKeyPath: WritableKeyPath<WaveEngine, CGFloat> {
  //    switch self {
  //      case .frequency: \.targetFrequency
  //      case .amplitude: \.targetAmplitude
  //      case .baseline: \.targetBaseline
  //      case .cyclesAcross: \.targetCyclesAcross
  //      case .noise: \.targetNoise
  //    }
  //  }

  var range: ClosedRange<Double> {
    switch self {
      case .amplitude: 0.01...5
      case .frequency: 0.01...20
      case .cyclesAcross: 0.1...10.0
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
