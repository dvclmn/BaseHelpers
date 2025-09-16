//
//  LegibilityDarkenModifier.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 16/9/2025.
//

import SwiftUI

struct LegibilityDarkenAdjuster {
  static func adjust(
    //    current hsv: HSVColour,
    hue h: CGFloat = 0.0,
    saturation s: CGFloat = 1.0,
    brightness v: CGFloat = 0.0,
    strength: CGFloat,
    hueShift: CGFloat
      //  ) -> HSVAdjustment {
      //    let h = hsv.hue
      //    let s = hsv.saturation
      //    let v = hsv.brightness
  ) -> (h: CGFloat, s: CGFloat, v: CGFloat) {
    let newSaturation: CGFloat = (s * (1.0 + 0.2 * strength)).clamped(to: 0...1)
    let newBrightness: CGFloat = (v + -0.1 * strength).clamped(to: 0...1)
    let newHue: CGFloat = (h + (hueShift / 360)).truncatingRemainder(dividingBy: 1).toUnitIntervalCyclic.value
    //    return HSVAdjustment(h: newHue, s: newSaturation, v: newBrightness)
    return (newHue, newSaturation, newBrightness)
  }
}

// MARK: - View Modifier
public struct LegibilityDarkenModifier: ViewModifier {
  let strength: CGFloat
  let hueShift: CGFloat

  public func body(content: Content) -> some View {
    ZStack {
      content
        .saturation(
          LegibilityDarkenAdjuster.adjust(
            strength: strength,
            hueShift: hueShift
          ).s
        )
        .brightness(
          LegibilityDarkenAdjuster.adjust(
            strength: strength,
            hueShift: hueShift
          ).v
        )
        .hueRotation(
          .degrees(
            LegibilityDarkenAdjuster.adjust(
              strength: strength,
              hueShift: hueShift
            ).h * 360))
    }
  }
}
extension View {
  public func legibilityDarken(
    tint: Color = Color.blue.opacityMid,
    strength: CGFloat = 0.5,
    hueShift: CGFloat = 0
  ) -> some View {
    self.modifier(
      LegibilityDarkenModifier(
        strength: strength,
        hueShift: hueShift
      )
    )
  }
}

// MARK: - Shape Style
public struct LegibilityDarkenStyle: ShapeStyle {
  let tint: Color
  let strength: CGFloat
  let hueShift: CGFloat

  public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
    /// Get the resolved color in the current environment
    let resolved = tint.resolve(in: environment)
    /// Convert to HSV using your project's helper
    var hsv = HSVColour(resolved: resolved, name: nil)

    /// Adjust values
    let adjusted = LegibilityDarkenAdjuster.adjust(
      hue: hsv.hue.value,
      saturation: hsv.saturation.value,
      brightness: hsv.brightness.value,
      strength: strength,
      hueShift: hueShift
    )
    hsv.saturation = adjusted.s.toUnitInterval
    hsv.brightness = adjusted.v.toUnitInterval
    hsv.hue = adjusted.h.toUnitIntervalCyclic

    /// Make a new Color from HSV
    let adjustedColor = hsv.swiftUIColour

    return adjustedColor
  }
}

/// `self` as Base colour
extension Color {
  public func legibilityDarken(
    tint: Color = .blue.opacityMid,
    strength: CGFloat = 0.5,
    hueShift: CGFloat = 0
  ) -> AnyShapeStyle {
    AnyShapeStyle(
      LegibilityDarkenStyle(
        tint: tint,
        strength: strength,
        hueShift: hueShift
      )
    )
  }
  //  some View {
  //      self.modifier(
  //        LegibilityDarkenModifier(
  //          strength: strength,
  //          hueShift: hueShift
  //        )
  //      )
  //    }
}
