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

  public var hue: UnitIntervalCyclic?
  public var saturation: Double?
  public var brightness: Double?

  public init(
    hueCyclic: UnitIntervalCyclic? = nil,
    saturation: Double? = nil,
    brightness: Double? = nil
  ) {
    self.hue = hueCyclic
    self.saturation = saturation
    self.brightness = brightness
  }

  public init(
    hue: Double? = nil,
    saturation: Double? = nil,
    brightness: Double? = nil
  ) {
    self.init(hueCyclic: hue?.toUnitIntervalCyclic, saturation: saturation, brightness: brightness)
  }

  public init(
    h: Double? = nil,
    s: Double? = nil,
    v: Double? = nil,
  ) {
    self.init(hue: h, saturation: s, brightness: v)
  }
}

extension HSVAdjustment {

  public static func adjustments(
    from modifiers: [any HSVModifier]
  ) -> [Self] {
    /// Extracts just the adjustments from the provided modifiers
    return modifiers.map(\.adjustment)
  }

  public static var zero: HSVAdjustment {
    HSVAdjustment(h: nil, s: nil, v: nil)
  }

  public func interpolated(
    towards other: HSVAdjustment,
    strength: Double
  ) -> HSVAdjustment {
    HSVAdjustment(
      hueCyclic: hue.interpolated(towards: other.hue, strength: strength),
      saturation: saturation.interpolated(towards: other.saturation, strength: strength),
      brightness: brightness.interpolated(towards: other.brightness, strength: strength)
    )
  }
  
//  func scaleAll(by factor: Double) -> HSVAdjustment {
//    HSVAdjustment(
//      hue: hue.map { $0.value * factor },
//      saturation: saturation.map { $0 * factor },
//      brightness: brightness.map { $0 * factor }
//    )
//  }
//
//  func scale(
//    _ keyPath: WritableKeyPath<HSVAdjustment, Double>,
//    by factor: Double
//  ) -> HSVAdjustment {
//    var result = self
//    result[keyPath: keyPath] *= factor
//    return result
//  }

  /// With `interpolated`, `HSVAdjustment` now knows how to
  /// go from one instance of itself, to another, linearly interpolating.
  ///
  /// The key here is that a `HSVAdjustment` describes
  /// the properties neccesary to actually *change* a given colour.
  /// These values/presets are described elsewhere, such as
  /// `ColourModification` and `ContrastPreset` etc.
  ///
  /// But here, we can go from one, to another, which is very useful.
  //  func interpolated(
  //    towards other: HSVAdjustment,
  //    strength: Double
  //  ) -> HSVAdjustment {
  //    HSVAdjustment(
  //      hue: self.hue.interpolated(
  //        towards: other.hue,
  //        strength: strength
  //      ),
  //      saturation: self.saturation.interpolated(
  //        towards: other.saturation,
  //        strength: strength
  //      ),
  //      brightness: self.brightness.interpolated(
  //        towards: other.brightness,
  //        strength: strength
  //      )
  //    )
  //  }

  static func applyingModifiers(
    for colour: any ColourModel,
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose = .legibility,
    chroma: ColourChroma = .standard
  ) -> Self {

    /// We don't handle `strength` just yet; first we gather
    /// the modifiers together for processing.
    let lumThreshold: LuminanceThreshold = .init(from: colour)
    
    let contributors: [any HSVModifier] = [
      lumThreshold,
      purpose,
      chroma,
    ]
    let adjustments = adjustments(from: contributors)

    let combined = adjustments.combined(with: strength.adjustmentStrength)

    return combined
  }

}

public func + (lhs: HSVAdjustment, rhs: HSVAdjustment) -> HSVAdjustment {
  HSVAdjustment(
    hueCyclic: lhs.hue.combined(with: rhs.hue) { $0.interpolated(towards: $1, strength: 1.0)
    },
    saturation: lhs.saturation.combined(with: rhs.saturation, using: +),
    
    brightness: lhs.brightness.combined(with: rhs.brightness, using: +)
  )
}
