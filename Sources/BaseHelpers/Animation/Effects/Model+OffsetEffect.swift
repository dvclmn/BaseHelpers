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
  
//  public static var `default`: Self { Self(withIntensity: CGSize.zero) }
  public static var kind: EffectKind { .offset }

//  public var width: CGFloat
//  public var height: CGFloat
  public var intensity: Intensity
  public var isEnabled: Bool = false
  
  public var waveComposition: WaveComposition = .empty

//  public init(
//    w width: CGFloat = .zero,
//    h height: CGFloat = .zero
//  ) {
//    self.intensity = CGSize(width: width, height: height)
//  }
  
  public init(withIntensity value: Intensity) {
    self.intensity = value
  }
  
  public init(fromKind kind: EffectKind, value: Intensity?) {
    self.intensity = value
  }

//  public var intensity: CGSize { CGSize(width: width, height: height) }
}
