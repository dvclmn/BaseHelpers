//
//  Model+ScaleEffect.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/8/2025.
//

import Foundation

public struct ScaleEffect: AnimatableEffect {
  public static var defaultIntensity: CGSize { CGSize(fromLength: 1.0) }
  public static var kind: EffectKind { .scale }
  
//  public var width: CGFloat
//  public var height: CGFloat
  public var intensity: CGSize
  public var isEnabled: Bool = false
  
  public var waveComposition: WaveComposition = .empty
  
//  public init(
//    w width: CGFloat,
//    h height: CGFloat
//  ) {
//    self.intensity = CGSize(width: width, height: height)
//  }
  public init(withIntensity value: CGSize) {
    self.intensity = value
  }
  
  
}
