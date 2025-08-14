//
//  Model+EffectDictionary.swift
//  AnimationVisualiser
//
//  Created by Dave Coleman on 23/11/2024.
//

//import Foundation

//protocol EffectDictionary {
//  
//  static func defaultValue() -> Self
//}
//
//extension WaveConfiguration: EffectDictionary {
//  static func defaultValue() -> Self { .default }
//}
//
//extension WaveState: EffectDictionary {
//  static func defaultValue() -> Self { .default }
//}
//
//
///// Generic dictionary helpers
//extension Dictionary where Key == EffectKey, Value: EffectDictionary {
//  mutating func mergeEffect(
//    _ other: Self,
//    preferring strategy: (Value, Value) -> Value = { current, _ in current }
//  ) {
//    merge(other, uniquingKeysWith: strategy)
//  }
//  
//  static func combining(_ dicts: Self...) -> Self {
//    dicts.reduce(into: [:]) { result, next in
//      result.mergeEffect(next)
//    }
//  }
//}
