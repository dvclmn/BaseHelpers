//
//  Model+WaveformType.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/8/2025.
//

import Foundation

public enum WaveformType: String, Codable {
  case sine
  case triangle
  case square
  case sawtooth
  
  public func calculate(_ phase: Double) -> Double {
    switch self {
      case .sine:
        return sin(phase)
      case .triangle:
        let normalised = phase / (2 * .pi)
        let fract = normalised - floor(normalised)
        return 1 - abs((fract * 4) - 2)
      case .square:
        return sin(phase) >= 0 ? 1 : -1
      case .sawtooth:
        let normalised = phase / (2 * .pi)
        return 2 * (normalised - floor(normalised) - 0.5)
    }
  }
}
