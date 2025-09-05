//
//  Model+Effects.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/8/2025.
//

import SwiftUI

/// Wonder if I merge all effects into a single thing
//public struct Effect: Model {
//  var axisA: SmoothedProperty
//  var axisB: SmoothedProperty
//
//
//}

public protocol WaveOutput: ModelBase {
  static func defaultValue(forKind kind: EffectKind) -> Self
}

public typealias WaveTransform<T> = @Sendable (CGFloat) -> T
//public typealias WaveTransform<T> = @Sendable (CGFloat, CGFloat) -> T

/// A generic property whose value is driven by a Wave.
public struct Effect<T: WaveOutput>: Sendable, Codable {

  public let kind: EffectKind
  /// Optional: base value around which the wave oscillates.
  public var intensity: T

  /// The base wave value is always a scalar between -1...1
  public var waveComposition: WaveComposition

  /// How to transform the wave’s scalar output into the effect’s Value.
  private var transform: WaveTransform<T>? = nil

  enum CodingKeys: String, CodingKey {
    case kind
    case intensity
    case waveComposition
  }

  public init(
    kind: EffectKind,
    intensity: T,
    waveComposition: WaveComposition,
    transform: WaveTransform<T>? = nil
  ) {
    self.kind = kind
    self.intensity = intensity
    self.waveComposition = waveComposition
    self.transform = transform
  }

  /// Returns the current value given a normalised wave position (0...1)
  public func value(
    elapsed: CGFloat,
    waveLibrary: [Wave]
  ) -> T {
    let waveScalar = waveComposition.value(elapsed: elapsed, waveLibrary: waveLibrary)
    return transform?(waveScalar) ?? T.defaultValue(forKind: self.kind)
  }

  // Mutating helpers for bindings
  //  mutating func setBase(_ newBase: T) {
  //    base = newBase
  //  }

  public mutating func updateWaveComposition(_ new: WaveComposition) {
    waveComposition = new
  }
}

extension CGFloat: WaveOutput {
  public static func defaultValue(forKind kind: EffectKind) -> Self {
    switch kind {
      case .offset, .scale: CGFloat.zero  // N/A
      case .blur: CGFloat.zero
    }
  }
}
//@available(macOS 15.0, *)
extension CGSize: WaveOutput {
  public static func defaultValue(forKind kind: EffectKind) -> Self {
    switch kind {
      case .offset: CGSize.zero
      case .scale: CGSize(fromLength: 1.0)
      case .blur: CGSize.zero  // N/A
    }
  }
}
extension Angle: WaveOutput {
  public static func defaultValue(forKind kind: EffectKind) -> Self {
    switch kind {
      case .offset, .scale, .blur: Angle.zero  // N/A
    }
  }
}

extension Effect where T == CGFloat {

  public static var defaultBlur: Self {
    Self(
      kind: .blur,
      intensity: 8,
      waveComposition: WaveComposition(),
    )
  }

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
    ) { scalar in
      scalar * amplitude
    }
  }
}

extension Effect where T == CGSize {

  public static var defaultOffset: Self {
    Self(
      kind: .offset,
      intensity: CGSize(fromLength: 20),
      waveComposition: WaveComposition(),
    )
  }

  public static var defaultScale: Self {
    Self(
      kind: .scale,
      intensity: CGSize(fromLength: 10),
      waveComposition: WaveComposition(),
    )
  }

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
    ) { scalar in
      CGSize(
        width: intensity.width + scalar * amplitude.width,
        height: intensity.height + scalar * amplitude.height
      )
    }
  }
}

extension Effect where T == Angle {
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
    ) { scalar in
      Angle(degrees: intensity.degrees + scalar * amplitude.degrees)
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
