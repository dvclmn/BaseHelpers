//
//  Model+WaveParameter.swift
//  AnimationVisualiser
//
//  Created by Dave Coleman on 4/11/2024.
//

import Foundation

protocol WavePropertyBase: Sendable, CaseIterable, Equatable, Identifiable {}

// MARK: - Shape Properties
public enum WaveShapeProperty: String, WavePropertyBase {
  case cyclesAcross

  public var id: String { rawValue }

  public var name: (full: String, abbreviated: String) {
    switch self {
      case .cyclesAcross: ("Cycles Across", "Cycles")
    }
  }

  public var defaultValue: CGFloat {
    switch self {
      case .cyclesAcross: 2.0
    }
  }

//  var targetKeyPath: WritableKeyPath<WaveProperties.Shape, CGFloat> {
//    switch self {
//      case .cyclesAcross: \.targetCyclesAcross
//    }
//  }
//
//  var displayedKeyPath: WritableKeyPath<WaveProperties.Shape, CGFloat> {
//    switch self {
//      case .cyclesAcross: \.displayedCyclesAcross
//    }
//  }
}

// MARK: - Engine Properties
public enum WaveEngineProperty: String, WavePropertyBase {

  /// How visually apparent is the oscillation effect. Aka strength
  case amplitude

  /// How rapidly does the oscillation occur. Aka speed
  case frequency

  /// How much irregularity is introduced into the overall wave / movement
  case noise
  case phaseOffset

  public var id: String { rawValue }

  public var name: (full: String, abbreviated: String) {
    switch self {
      case .amplitude: ("Amplitude", "Amp")
      case .frequency: ("Frequency", "Freq")
      case .noise: ("Noise", "Noise")
      case .phaseOffset: ("Phase Offset", "Phase")
    }
  }

  public var defaultValue: Double {
    switch self {
      case .amplitude: 20
      case .frequency: 1.0
      case .noise: 0.0
      case .phaseOffset: 0.0
    }
  }

  public var icon: String {
    switch self {
      case .amplitude: "cellularbars"  // lines.measurement.horizontal, speaker.wave.2
      case .frequency: "waveform.path.ecg"
      //      case .phase: "point.forward.to.point.capsulepath"
      case .noise: "dice"  // glowplug, scribble
      case .phaseOffset: "eye"  // glowplug, scribble
    //      case .cyclesAcross: "eye"
    }
  }

//  @MainActor
//  public var displayedKeyPath: WritableKeyPath<WaveProperties.Engine, CGFloat> {
//    switch self {
//      case .frequency: \.displayedFrequency
//      case .amplitude: \.displayedAmplitude
//      case .noise: \.displayedNoise
//      case .phaseOffset: \.displayedPhaseOffset
//    }
//  }
//
////  @MainActor
//  public var targetKeyPath: WritableKeyPath<WaveProperties.Engine, CGFloat> {
//    switch self {
//      case .frequency: \.targetFrequency
//      case .amplitude: \.targetAmplitude
//      case .noise: \.targetNoise
//      case .phaseOffset: \.targetPhaseOffset
//    }
//  }

  public var range: ClosedRange<Double> {
    switch self {
      case .amplitude: 0.01...60
      case .frequency: 0.01...20
      //      case .cyclesAcross: 0.1...10.0
      case .noise: 0...4
      case .phaseOffset: 0...twoPi
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
