//
//  Handler+WaveProperties.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 16/8/2025.
//

import SwiftUI

@MainActor
public struct WaveProperties: Sendable, Equatable {
  
  /// Public, user-controlled targets (bind these to sliders)
  public var targetAmplitude: CGFloat = WaveProperty.amplitude.defaultValue
  public var targetFrequency: CGFloat = WaveProperty.frequency.defaultValue
  public var targetCyclesAcross: CGFloat = WaveProperty.cyclesAcross.defaultValue
  public var targetNoise: CGFloat = WaveProperty.noise.defaultValue
  
  /// Smoothed/displayed values (what the renderer uses)
  public var displayedAmplitude: CGFloat = .zero
  public var displayedFrequency: CGFloat = .zero
  public var displayedCyclesAcross: CGFloat = .zero
  public var displayedNoise: CGFloat = .zero
  
  public init() {}
}

extension WaveProperties {
  mutating func computePropertyThing(_ property: WaveProperty, alpha: CGFloat) {
    let delta = self[keyPath: property.targetKeyPath] - self[keyPath: property.displayedKeyPath]
    self[keyPath: property.displayedKeyPath] += delta * alpha
  }
  
  mutating func computeSnap(_ property: WaveProperty) {
    self[keyPath: property.displayedKeyPath] = self[keyPath: property.targetKeyPath]
  }
  
}
