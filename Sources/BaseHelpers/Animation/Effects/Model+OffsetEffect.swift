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

public protocol WaveOutput: Sendable, Codable, Equatable {
  static func defaultValue(for): Self { get }
}

public typealias WaveTransform<T> = @Sendable (CGFloat, CGFloat) -> T

/// A generic property whose value is driven by a Wave.
public struct Effect<T: WaveOutput>: Documentable {
  
  public static var kind: EffectKind
  /// The base wave value is always a scalar between -1...1
  //  var wave: Wave
  //  public var wave: S
  public var waveComposition: WaveComposition

  /// How to transform the wave’s scalar output into the effect’s Value.
  private var transform: WaveTransform<T> = { _, _ in return T.defaultValue}
  //  private var transform: (CGFloat) -> Value

  /// Optional: base value around which the wave oscillates.
    var intensity: T

  enum CodingKeys: String, CodingKey {
        case base
    case waveComposition
  }

  public init(
    kind: EffectKind,
    intensity: T,
    waveComposition: WaveComposition,
    transform: @escaping WaveTransform<T>
  ) {
    self.kind = kind
    self.intensity = intensity
    self.waveComposition = waveComposition
    self.transform = transform
  }

  /// Returns the current value given a normalised wave position (0...1)
  public func value(elapsed: CGFloat) -> T {
    let waveScalar = wave.value(elapsed: elapsed)  // CGFloat -1...1
    return transform(waveScalar)
  }

  // Mutating helpers for bindings
  //  mutating func setBase(_ newBase: T) {
  //    base = newBase
  //  }

  public mutating func updateWave(_ newWave: Wave) {
    wave = newWave
  }
}

extension CGFloat: WaveOutput {
  static var defaultValue: CGFloat
}
extension CGSize: WaveOutput {}
extension Angle: WaveOutput {}

extension WaveDrivenProperty where T == CGFloat {
  public static func scalar(
    kind: EffectKind,
    intensity: CGFloat,
    amplitude: CGFloat,
    waveComposition: WaveComposition,
  ) -> Self {
    Self(
      kind: kind,
      intensity: intensity,
      waveComposition: waveComposition
      ) { axisA, axisB in
      scalar * amplitude
    }
  }
}

extension WaveDrivenProperty where T == CGSize {
  public static func size(
    kind: EffectKind,
    intensity: CGSize,
    amplitude: CGSize,
    waveComposition: WaveComposition,
  ) -> Self {
    Self(
      kind: kind,
      intensity: intensity,
      waveComposition: waveComposition
    ) { axisA, axisB in
      CGSize(
        width: intensity + axisA * amplitude.width,
        height: intensity + axisB * amplitude.height
      )
    }
  }
}

extension WaveDrivenProperty where T == Angle {
  public static func angle(
    kind: EffectKind,
    intensity: Angle,
    amplitude: Angle,
    waveComposition: WaveComposition,
  ) -> Self {
    Self(
      kind: kind,
      intensity: intensity,
      waveComposition: waveComposition
    ) { axisA, axisB in
      Angle(degrees: intensity + axisA * amplitude.degrees)
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
