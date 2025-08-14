//
//  Models.swift
//  Components
//
//  Created by Dave Coleman on 29/10/2024.
//

import SwiftUI
import BaseStyles
import BaseHelpers


public struct EffectKey: Documentable {
  public let effect: AnimatedEffect
  public let dimension: AnimatedEffect.Dimension
  
  public init(
    effect: AnimatedEffect,
    dimension: AnimatedEffect.Dimension
  ) {
    self.effect = effect
    self.dimension = dimension
  }
//  let defaultValue: Double
}

extension EffectKey {
  
  struct Rotation: EffectGroup {
    static let effect: AnimatedEffect = .rotation
    static let degrees = EffectKey(effect: effect, dimension: .degrees)
  }
  
  struct Offset: EffectGroup {
    static let effect: AnimatedEffect = .offset
    static let horizontal = EffectKey(effect: effect, dimension: .horizontal)
    static let vertical = EffectKey(effect: effect, dimension: .vertical)
  }

  struct Skew: EffectGroup {
    static let effect: AnimatedEffect = .skew
    static let horizontal = EffectKey(effect: effect, dimension: .horizontal)
    static let vertical = EffectKey(effect: effect, dimension: .vertical)
  }
  
  struct WaveDistort: EffectGroup {
    static let effect: AnimatedEffect = .waveDistort
    static let count = EffectKey(effect: effect, dimension: .count)
    static let speed = EffectKey(effect: effect, dimension: .speed)
    static let strength = EffectKey(effect: effect, dimension: .strength)
  }
  
  struct Hue: EffectGroup {
    static let effect: AnimatedEffect = .hue
    static let degrees = EffectKey(effect: effect, dimension: .degrees)
  }

  
  struct Scale: EffectGroup {
    static let effect: AnimatedEffect = .scale
    static let horizontal = EffectKey(effect: effect, dimension: .horizontal)
    static let vertical = EffectKey(effect: effect, dimension: .vertical)
  }

  struct Blur: EffectGroup {
    static let effect: AnimatedEffect = .blur
    static let strength = EffectKey(effect: effect, dimension: .strength)
  }
  struct Opacity: EffectGroup {
    static let effect: AnimatedEffect = .opacity
    static let strength = EffectKey(effect: effect, dimension: .strength)
  }
  
  struct Brightness: EffectGroup {
    static let effect: AnimatedEffect = .brightness
    static let strength = EffectKey(effect: effect, dimension: .strength)
  }
  
}


extension EffectKey {
  
  /// Add a way to get all keys for a specific effect
  static func allKeys(for effect: AnimatedEffect) -> Set<EffectKey> {
    effect.allKeys
  }
  
}


extension EffectKey: CustomStringConvertible {
  var description: String {
    "EffectKey(Effect: \(effect.name), Dimension: \(dimension.name))"
  }
}


extension AnimatedEffect {
  func keys() -> [EffectKey] {
    dimensions.map { EffectKey(effect: self, dimension: $0) }
  }
  
  static var allKeys: [EffectKey] {
    Self.allCases.flatMap { effect in
      effect.dimensions.map { dimension in
        EffectKey(effect: effect, dimension: dimension)
      }
    }
  }

  /// Get all `EffectKey`s for this effect
  ///
  /// Also valid:
  ///
  /// ```
  /// var allKeys: Set<EffectKey> {
  ///   dimensions.map(into: Set<EffectKey>()) { set, dimension in
  ///     set.insert(EffectKey(effect: self, dimension: dimension))
  ///   }
  /// }
  /// ```
  ///
  var allKeys: Set<EffectKey> {
    Set(dimensions.map { dimension in
      EffectKey(effect: self, dimension: dimension)
    })
  }
  
}

