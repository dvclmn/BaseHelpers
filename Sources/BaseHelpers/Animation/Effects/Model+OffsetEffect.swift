//
//  Model+Effects.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/8/2025.
//

import SwiftUI

public struct OffsetEffect: AnimatableEffect {

  public typealias Intensity = CGSize
  public static var defaultIntensity: Intensity { Intensity.zero }

  public static var kind: EffectKind { .offset }

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
//  public init(withIntensity value: Intensity) {
//    self.intensity = value
//  }


}
