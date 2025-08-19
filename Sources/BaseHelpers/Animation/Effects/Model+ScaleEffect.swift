//
//  Model+ScaleEffect.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/8/2025.
//

import Foundation

public struct ScaleEffect: AnimatableEffect {
  public typealias Intensity = CGSize
  
  public static var defaultIntensity: Intensity { Intensity(fromLength: 1.0) }
  public static var kind: EffectKind { .scale }
  
  public var intensity: Intensity
  public var isEnabled: Bool
  
  public var waveComposition: WaveComposition = .empty

  public init(
    fromKind kind: EffectKind,
    value: Intensity? = nil,
    isEnabled: Bool = false
  ) {
    self.init(
      withIntensity: value,
      isEnabled: isEnabled
    )
  }
  
  public init(
    withIntensity value: Intensity?,
    isEnabled: Bool
  ) {
    self.intensity = value ?? Self.defaultIntensity
    self.isEnabled = isEnabled
  }
//  public init(withIntensity value: CGSize) {
//    self.intensity = value
//  }
  
  
}
