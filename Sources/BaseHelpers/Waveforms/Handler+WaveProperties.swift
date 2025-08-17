//
//  Handler+WaveProperties.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 16/8/2025.
//

import SwiftUI

@MainActor
public struct WaveProperties: Sendable, Equatable {
  
  // MARK: - Engine domain
  /// The oscillating CGFloat wave value
  public struct Engine: Sendable, Equatable {
    public var targetAmplitude: CGFloat = WaveEngineProperty.amplitude.defaultValue
    public var targetFrequency: CGFloat = WaveEngineProperty.frequency.defaultValue
    public var targetNoise: CGFloat = WaveEngineProperty.noise.defaultValue
    
    public var displayedAmplitude: CGFloat = .zero
    public var displayedFrequency: CGFloat = .zero
    public var displayedNoise: CGFloat = .zero
  }
  
  // MARK: - Shape domain
  /// How the wave is drawn (Canvas, Shape)
  public struct Shape: Sendable, Equatable {
    public var targetCyclesAcross: CGFloat = WaveShapeProperty.cyclesAcross.defaultValue
    public var displayedCyclesAcross: CGFloat = .zero
  }
  
  public var engine = Engine()
  public var shape = Shape()
}

//public struct WaveProperties: Sendable, Equatable {
//  public struct Engine: Equatable {
//    public var targetAmplitude: CGFloat = 20
//    public var targetFrequency: CGFloat = 1
//    public var targetNoise: CGFloat = 0
//    public var displayedAmplitude: CGFloat = .zero
//    public var displayedFrequency: CGFloat = .zero
//    public var displayedNoise: CGFloat = .zero
//  }
//  
//  public struct Shape: Equatable {
//    public var targetCyclesAcross: CGFloat = 2
//    public var displayedCyclesAcross: CGFloat = .zero
//  }
//  
//  public var engine = Engine()
//  public var shape = Shape()
//}
//
//
//@MainActor
//public struct WaveProperties: Sendable, Equatable {
//
//  /// Public, user-controlled targets (bind these to sliders)
//  public var targetAmplitude: CGFloat = WaveProperty.amplitude.defaultValue
//  public var targetFrequency: CGFloat = WaveProperty.frequency.defaultValue
////  public var targetCyclesAcross: CGFloat = WaveProperty.cyclesAcross.defaultValue
//  public var targetNoise: CGFloat = WaveProperty.noise.defaultValue
//
//  /// Smoothed/displayed values (what the renderer uses)
//  public var displayedAmplitude: CGFloat = .zero
//  public var displayedFrequency: CGFloat = .zero
////  public var displayedCyclesAcross: CGFloat = .zero
//  public var displayedNoise: CGFloat = .zero
//
//  public init() {}
//}

extension WaveProperties {

  mutating func updateProperty(
    _ property: WaveProperty,
    with updateType: PropertyUpdateType,
  ) {
    switch updateType {
      case .alpha(let alphaValue):
        let delta = self[keyPath: property.targetKeyPath] - self[keyPath: property.displayedKeyPath]
        self[keyPath: property.displayedKeyPath] += delta * alphaValue

      case .snap:
        self[keyPath: property.displayedKeyPath] = self[keyPath: property.targetKeyPath]
    }

  }
}

enum PropertyUpdateType {
  case alpha(CGFloat)
  case snap
}
