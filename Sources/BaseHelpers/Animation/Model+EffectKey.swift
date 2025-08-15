//
//  Models.swift
//  Components
//
//  Created by Dave Coleman on 29/10/2024.
//

import SwiftUI

public struct EffectKey: Documentable {
  public let effect: AnimatedEffect
  public let dimension: EffectDimension

  public init(
    effect: AnimatedEffect,
    dimension: EffectDimension
  ) {
    self.effect = effect
    self.dimension = dimension
  }
  //  let defaultValue: Double
}


extension EffectKey {
  
  /// Add a way to get all keys for a specific effect
  public static func allKeys(for effect: AnimatedEffect) -> Set<EffectKey> {
    effect.allKeys
  }

  public struct Rotation: EffectGroup {
    public static let effect: AnimatedEffect = .rotation
    public static let degrees = EffectKey(effect: effect, dimension: .degrees)
  }

  public struct Offset: EffectGroup {
    public static let effect: AnimatedEffect = .offset
    public static let horizontal = EffectKey(effect: effect, dimension: .horizontal)
    public static let vertical = EffectKey(effect: effect, dimension: .vertical)
  }

  public struct Skew: EffectGroup {
    public static let effect: AnimatedEffect = .skew
    public static let horizontal = EffectKey(effect: effect, dimension: .horizontal)
    public static let vertical = EffectKey(effect: effect, dimension: .vertical)
  }

  public struct WaveDistort: EffectGroup {
    public static let effect: AnimatedEffect = .waveDistort
    public static let count = EffectKey(effect: effect, dimension: .count)
    public static let speed = EffectKey(effect: effect, dimension: .speed)
    public static let strength = EffectKey(effect: effect, dimension: .strength)
  }

  public struct Hue: EffectGroup {
    public static let effect: AnimatedEffect = .hue
    public static let degrees = EffectKey(effect: effect, dimension: .degrees)
  }

  public struct Scale: EffectGroup {
    public static let effect: AnimatedEffect = .scale
    public static let horizontal = EffectKey(effect: effect, dimension: .horizontal)
    public static let vertical = EffectKey(effect: effect, dimension: .vertical)
  }

  public struct Blur: EffectGroup {
    public static let effect: AnimatedEffect = .blur
    public static let strength = EffectKey(effect: effect, dimension: .strength)
  }
  public struct Opacity: EffectGroup {
    public static let effect: AnimatedEffect = .opacity
    public static let strength = EffectKey(effect: effect, dimension: .strength)
  }

  public struct Brightness: EffectGroup {
    public static let effect: AnimatedEffect = .brightness
    public static let strength = EffectKey(effect: effect, dimension: .strength)
  }

}


extension EffectKey: CustomStringConvertible {
  public var description: String {
    "EffectKey(Effect: \(effect.name), Dimension: \(dimension.name))"
  }
}

extension AnimatedEffect {
  public func keys() -> [EffectKey] {
    dimensions.map { EffectKey(effect: self, dimension: $0) }
  }

  public static var allKeys: [EffectKey] {
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
  public var allKeys: Set<EffectKey> {
    Set(
      dimensions.map { dimension in
        EffectKey(effect: self, dimension: dimension)
      })
  }

}
