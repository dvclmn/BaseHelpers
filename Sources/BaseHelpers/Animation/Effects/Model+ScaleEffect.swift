//
//  Model+ScaleEffect.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/8/2025.
//

import Foundation

public struct ScaleEffect: AnimatableEffect {
  public static var `default`: Self { Self(w: 1.0, h: 1.0) }
  public static var kind: EffectKind { .scale }
  
  let width: CGFloat
  let height: CGFloat
  public var waveComposition: WaveComposition = .empty
  
  public init(
    w width: CGFloat = .zero,
    h height: CGFloat = .zero
  ) {
    self.width = width
    self.height = height
  }
  public init(withIntensity value: CGSize) {
    self.init(w: value.width, h: value.height)
  }
  
  public var intensity: CGSize { CGSize(width: width, height: height) }
  
}
