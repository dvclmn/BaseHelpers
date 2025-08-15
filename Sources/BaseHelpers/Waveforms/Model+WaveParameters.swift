//
//  Model+WaveParameter.swift
//  AnimationVisualiser
//
//  Created by Dave Coleman on 4/11/2024.
//

import Foundation
import BaseComponents
import BaseHelpers


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

enum WaveParameter: CaseIterable, Identifiable {
  
  /// How visually apparent is the oscillation effect. Aka strength
  case amplitude
  
  /// How rapidly does the oscillation occur. Aka speed
  case frequency
  
  /// When in time is the 'start point' located (can help to offset against other effects)
  case phase
  
  /// How much irregularity is introduced into the overall wave / movement
  case noise
  
  static var activeParameters: [WaveParameter] {
    [.amplitude, .frequency, .phase]
  }
  
  var id: String {
    self.name
  }

  var name: String {
    switch self {
      case .amplitude: "Amplitude"
      case .frequency: "Frequency"
      case .phase: "Phase"
      case .noise: "Noise"
    }
  }
  
  var abbreviatedName: String {
    switch self {
      case .amplitude: "Amp"
      case .frequency: "Freq"
      case .phase: "Phase"
      case .noise: "Noise"
    }
  }
  
  var icon: String {
    switch self {
      case .amplitude: return "cellularbars" // lines.measurement.horizontal, speaker.wave.2
      case .frequency: return "waveform.path.ecg"
      case .phase: return "point.forward.to.point.capsulepath"
      case .noise: return "dice" // glowplug, scribble
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
      case .amplitude: 0.01...1
      case .frequency: 0.01...20
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

