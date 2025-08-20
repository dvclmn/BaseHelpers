//
//  Model+Effects.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/8/2025.
//

import SwiftUI

/// Wonder if I merge all effects into a single thing
//public struct Effect: Documentable {
//  var axisA: SmoothedProperty
//  var axisB: SmoothedProperty
//  
//  
//}

public protocol WaveOutput: Sendable, Equatable {}

public typealias WaveTransform<T> = @Sendable (CGFloat, CGFloat) -> T

/// A generic property whose value is driven by a Wave.
struct WaveDrivenProperty<T: WaveOutput>: Documentable {
  /// The base wave value is always a scalar between -1...1
//  var wave: Wave
  var wave: any WaveSource
  
  /// How to transform the wave’s scalar output into the effect’s Value.
  private var transform: WaveTransform<T>
//  private var transform: (CGFloat) -> Value
  
  /// Optional: base value around which the wave oscillates.
//  var base: T
  
  enum CodingKeys: String, CodingKey {
//    case base
    case wave
  }
  
  init(
//    base: T,
    wave: any WaveSource,
    transform: @escaping WaveTransform<T>
  ) {
//    self.base = base
    self.wave = wave
    self.transform = transform
  }
  
  /// Returns the current value given a normalised wave position (0...1)
  func value(at time: TimeInterval) -> T {
    let waveScalar = wave.value(at: time) // CGFloat -1...1
    return transform(waveScalar)
  }
  
  // Mutating helpers for bindings
//  mutating func setBase(_ newBase: T) {
//    base = newBase
//  }
  
  mutating func updateWave(_ newWave: Wave) {
    wave = newWave
  }
}

extension CGFloat: WaveOutput {}
extension CGSize: WaveOutput {}
extension Angle: WaveOutput {}

extension WaveDrivenProperty where T == CGFloat {
  static func scalar(amplitude: CGFloat, wave: Wave) -> Self {
    Self(wave: wave) { scalar in
      scalar * amplitude
    }
  }
}

extension WaveDrivenProperty where T == CGSize {
  static func size(amplitude: CGSize, wave: Wave) -> Self {
    Self(wave: wave) { scalar in
      CGSize(
        width: scalar * amplitude.width,
        height: scalar * amplitude.height
      )
    }
  }
}

extension WaveDrivenProperty where T == Angle {
  static func angle(amplitude: Angle, wave: Wave) -> Self {
    Self(wave: wave) { scalar in
      Angle(degrees: scalar * amplitude.degrees)
    }
  }
}

//public struct OffsetEffect: AnimatableEffect {
//
//  var offset: WaveDrivenProperty<CGSize>
//  
////  public typealias Intensity = CGSize
////  public static var defaultIntensity: Intensity { Intensity.zero }
////
////  public static var kind: EffectKind { .offset }
////
////  public var intensity: Intensity
////  public var isEnabled: Bool
////
////  public var waveComposition: WaveComposition = .empty
////
////  public init(
////    fromKind kind: EffectKind,
////    value: Intensity? = nil,
////    isEnabled: Bool = false
////  ) {
////    self.init(
////      withIntensity: value,
////      isEnabled: isEnabled
////    )
////  }
////
////  public init(
////    withIntensity value: Intensity?,
////    isEnabled: Bool
////  ) {
////    self.intensity = value ?? Self.defaultIntensity
////    self.isEnabled = isEnabled
////  }
//  //  public init(withIntensity value: Intensity) {
//  //    self.intensity = value
//  //  }
//
//}
