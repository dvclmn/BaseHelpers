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
  @MainActor
  public struct Engine: Sendable, Equatable {
    public var targetAmplitude: CGFloat = WaveEngineProperty.amplitude.defaultValue
    public var targetFrequency: CGFloat = WaveEngineProperty.frequency.defaultValue
    public var targetNoise: CGFloat = WaveEngineProperty.noise.defaultValue
    public var targetPhaseOffset: CGFloat = WaveEngineProperty.phaseOffset.defaultValue

    public var displayedAmplitude: CGFloat = .zero
    public var displayedFrequency: CGFloat = .zero
    public var displayedNoise: CGFloat = .zero
    public var displayedPhaseOffset: CGFloat = .zero
  }

  // MARK: - Shape domain
  /// How the wave is drawn (Canvas, Shape)
  @MainActor
  public struct Shape: Sendable, Equatable {
    public var targetCyclesAcross: CGFloat = WaveShapeProperty.cyclesAcross.defaultValue
    public var displayedCyclesAcross: CGFloat = .zero
  }

  public var engine = Engine()
  public var shape = Shape()
}

extension WaveProperties.Engine {

  mutating func updateProperty(
    _ property: WaveEngineProperty,
    with updateType: PropertyUpdateType
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

extension WaveProperties.Shape {
  mutating func updateProperty(
    _ property: WaveShapeProperty,
    with updateType: PropertyUpdateType
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
