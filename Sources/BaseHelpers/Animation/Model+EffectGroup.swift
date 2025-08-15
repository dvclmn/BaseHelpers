//
//  Model+EffectGroup.swift
//  AnimationVisualiser
//
//  Created by Dave Coleman on 23/11/2024.
//

import Foundation

protocol EffectGroup {
  static var effect: AnimatedEffect { get }
}

extension EffectGroup {
  #warning("Temporary placeholder")
  static var effect: AnimatedEffect { .hue }
}

//extension EffectGroup {
//  static var allKeys: Set<EffectKey> {
//    EffectKey.allKeys(for: effect)
//  }
//  
//  /// Generic method for any EffectDictionary type
//  static func defaultValues<T: EffectDictionary>(using value: T = T.defaultValue()) -> [EffectKey: T] {
//    Dictionary(uniqueKeysWithValues: allKeys.map { ($0, value) })
//  }
//  
//  /// Now these become simple typealiases of the generic method
//  static func defaultConfigs(using config: WaveConfiguration = .default) -> [EffectKey: WaveConfiguration] {
//    defaultValues(using: config)
//  }
//  
//  static func defaultStates(using state: WaveState = .default) -> [EffectKey: WaveState] {
//    defaultValues(using: state)
//  }
//  
//  /// Usage:
//  ///
//  /// ```
//  /// let customSkewConfigs = EffectKey.Skew.customConfigs(configs: [
//  ///   .horizontal: .gentle,
//  ///   .vertical: .exaggerated
//  /// ])
//  /// ```
//  
//  /// Generic custom values method. Previous solution was:
//  /// ```
//  /// static func customConfigs(configs: [EffectDimension: WaveConfiguration]) -> Configs {
//  ///   allKeys.reduce(into: [:]) { result, key in
//  ///     result[key] = configs[key.dimension] ?? .default
//  ///   }
//  /// }
//  /// ```
//  static func customValues<T: EffectDictionary>(values: [EffectDimension: T]) -> [EffectKey: T] {
//    allKeys.reduce(into: [:]) { result, key in
//      result[key] = values[key.dimension] ?? T.defaultValue()
//    }
//  }
//  
//  // Type-specific versions for convenience
//  static func customConfigs(configs: [EffectDimension: WaveConfiguration]) -> [EffectKey: WaveConfiguration] {
//    customValues(values: configs)
//  }
//  
//  static func customStates(states: [EffectDimension: WaveState]) -> [EffectKey: WaveState] {
//    customValues(values: states)
//  }
//  
//  /// Check if a key belongs to this effect group
//  static func contains(_ key: EffectKey) -> Bool {
//    key.effect == effect
//  }
//  
//}
