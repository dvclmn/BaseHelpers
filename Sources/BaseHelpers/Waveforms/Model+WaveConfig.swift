//
//  Model+WaveConfig.swift
//  AnimationVisualiser
//
//  Created by Dave Coleman on 10/11/2024.
//

import Foundation

struct WaveConfiguration: Codable, Hashable, Sendable {
  var amplitude: Double
  var frequency: Double
  var phase: Double
  var noise: SmoothNoiseEngine
}

extension WaveConfiguration: CustomStringConvertible {
  var description: String {
    "WaveConfiguration(Amp: \(amplitude), Freq: \(frequency), Phase: \(phase))"
  }
}

extension WaveConfiguration {
  
  static let `default`: WaveConfiguration = .init(
    amplitude: 0.5,
    frequency: 0.2,
    phase: 0,
    noise: SmoothNoiseEngine()
  )
  
  static let exaggerated: WaveConfiguration = .init(
    amplitude: 1.0,
    frequency: 4.0,
    phase: 0,
    noise: SmoothNoiseEngine()
  )

  func value(for parameter: WaveParameter) -> Double {
    self[keyPath: parameter.keyPath]
  }
}
