//
//  Handler+WaveProperties.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 16/8/2025.
//

import SwiftUI

@MainActor
public struct WaveProperties: Sendable, Equatable {
  public var engine = Engine()
  public var shape = Shape()
}

extension WaveProperties {
  // MARK: - Engine domain
  /// The oscillating CGFloat wave value, used to drive animated effects
//  @MainActor
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
  /// How the wave is drawn to the Canvas, for visualisation in the UI
//  @MainActor
  public struct Shape: Sendable, Equatable {
    public var targetCyclesAcross: CGFloat = WaveShapeProperty.cyclesAcross.defaultValue
    public var displayedCyclesAcross: CGFloat = .zero
  }

}

extension WaveProperties.Engine {
  mutating func updateProperty(
    _ property: WaveEngineProperty,
    dt: CGFloat,
    timeConstant: CGFloat
  ) {
    let currentValue = self[keyPath: property.displayedKeyPath]
    let targetValue = self[keyPath: property.targetKeyPath]
    
    self[keyPath: property.displayedKeyPath] = currentValue.smoothed(
      towards: targetValue,
      dt: dt,
      timeConstant: timeConstant
    )
  }
}

extension WaveProperties.Shape {
  mutating func updateProperty(
    _ property: WaveShapeProperty,
    dt: CGFloat,
    timeConstant: CGFloat
  ) {
    let currentValue = self[keyPath: property.displayedKeyPath]
    let targetValue = self[keyPath: property.targetKeyPath]
    
    self[keyPath: property.displayedKeyPath] = currentValue.smoothed(
      towards: targetValue,
      dt: dt,
      timeConstant: timeConstant
    )
  }
}

//enum PropertyUpdateType {
//  case alpha(CGFloat)
//  case snap
//
//  init(fromDeltaTime deltaTime: TimeInterval, smoothingTimeConstant: TimeInterval) {
//    if deltaTime > 0 {
//      let thing: CGFloat = 1 - exp(-deltaTime / max(0.0001, smoothingTimeConstant))
//      self = .alpha(thing)
//    } else {
//      self = .snap
//    }
//  }
//}
