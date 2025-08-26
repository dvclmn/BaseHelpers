//
//  Model+HSVAdjustment.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/6/2025.
//

import Foundation

/// Represents a *delta* adjustment in HSV space
/// Does not set hsb values to these, but adds to them
public struct HSVAdjustment: Sendable {

  public var hue: Double?
  public var saturation: Double?
  public var brightness: Double?

  public init(
    hue: Double? = nil,
    saturation: Double? = nil,
    brightness: Double? = nil
  ) {
    self.hue = hue
    self.saturation = saturation
    self.brightness = brightness
  }

  public init(
    _ hue: Double? = nil,
    _ saturation: Double? = nil,
    _ brightness: Double? = nil,
  ) {
    self.init(hue: hue, saturation: saturation, brightness: brightness)
  }
}

extension HSVAdjustment {

  public static func adjustments(from modifiers: [any HSVModifier]) -> [Self] {
    let adjustments: [HSVAdjustment] = modifiers.map {
      $0.adjustment
    }
    return adjustments
  }

  public static let zero = HSVAdjustment(
    hue: 0,
    saturation: 0,
    brightness: 0
  )

  static func + (lhs: HSVAdjustment, rhs: HSVAdjustment) -> HSVAdjustment {
    HSVAdjustment(
      hue: lhs.hue.combined(with: rhs.hue, using: +),
      saturation: lhs.saturation.combined(with: rhs.saturation, using: +),
      brightness: lhs.brightness.combined(with: rhs.brightness, using: +)
    )
  }

  func scaleAll(by factor: Double) -> HSVAdjustment {
    HSVAdjustment(
      hue: hue.map { $0 * factor },
      saturation: saturation.map { $0 * factor },
      brightness: brightness.map { $0 * factor }
    )
  }

  func scale(
    _ keyPath: WritableKeyPath<HSVAdjustment, Double>,
    by factor: Double
  ) -> HSVAdjustment {
    var result = self
    result[keyPath: keyPath] *= factor
    return result
  }

  /// With `interpolated`, `HSVAdjustment` now knows how to
  /// go from one instance of itself, to another, linearly interpolating.
  ///
  /// The key here is that a `HSVAdjustment` describes
  /// the properties neccesary to actually *change* a given colour.
  /// These values/presets are described elsewhere, such as
  /// `ColourModification` and `ContrastPreset` etc.
  ///
  /// But here, we can go from one, to another, which is very useful.
  func interpolated(
    towards other: HSVAdjustment,
    strength: Double
  ) -> HSVAdjustment {
    HSVAdjustment(
      hue: self.hue.interpolated(towards: other.hue, strength: strength),
      saturation: self.saturation.interpolated(towards: other.saturation, strength: strength),
      brightness: self.brightness.interpolated(towards: other.brightness, strength: strength)
    )
  }

  static func applyingModifiers(
    for colour: any ColourModel,
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose = .legibility,
    chroma: ColourChroma = .standard
  ) -> Self {

    /// We don't handle `strength` just yet; first we gather
    /// the modifiers together for processing.
    ///
    /// What role does `LuminanceModifier` play here? Not sure.
    let lumThreshold: LuminanceThreshold = .init(from: colour)
    let contributors: [any HSVModifier] = [
      LuminanceModifier(threshold: lumThreshold),
      ColourPurposeModifier(purpose: purpose),
      ChromaModifier(chroma: chroma),
    ]
    let adjustments = adjustments(from: contributors)
    let combined = adjustments.combined(with: strength.adjustmentStrength)
    return combined
  }


}
