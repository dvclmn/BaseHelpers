//
//  LegibilityDarkenModifier.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 16/9/2025.
//

import SwiftUI

struct LegibilityDarkenAdjuster {
  static func adjust(
    saturation: CGFloat,
    brightness: CGFloat,
    hue: CGFloat,
    strength: CGFloat,
    hueShift: CGFloat
  ) -> (saturation: CGFloat, brightness: CGFloat, hue: CGFloat) {
        let newSaturation = (saturation * (1.0 + 0.2 * strength)).clamped(to: 0...1)
        let newBrightness = (brightness + -0.1 * strength).clamped(to: 0...1)
        let newHue = (hue + (hueShift / 360)).truncatingRemainder(dividingBy: 1).toUnitIntervalCyclic
        return (newSaturation, newBrightness, newHue)
    }
}


// MARK: - View Modifier
public struct LegibilityDarkenModifier: ViewModifier {
  let strength: CGFloat
  let hueShift: CGFloat

  public func body(content: Content) -> some View {
    ZStack {
      content
        .saturation(LegibilityDarkenAdjuster.adjust(
          saturation: 1.0,
          brightness: 0.0,
          hue: 0.0,
          strength: strength,
          hueShift: hueShift
        ).saturation)
        .brightness(LegibilityDarkenAdjuster.adjust(
          saturation: 1.0,
          brightness: 0.0,
          hue: 0.0,
          strength: strength,
          hueShift: hueShift
        ).brightness)
        .hueRotation(.degrees(LegibilityDarkenAdjuster.adjust(
          saturation: 1.0,
          brightness: 0.0,
          hue: 0.0,
          strength: strength,
          hueShift: hueShift
        ).hue * 360))
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
      saturation: hsv.saturation.value,
      brightness: hsv.brightness.value,
      hue: hsv.hue.value,
      strength: strength,
      hueShift: hueShift
    )
    hsv.saturation = adjusted.saturation.toUnitInterval
    hsv.brightness = adjusted.brightness.toUnitInterval
    hsv.hue = adjusted.hue.toUnitIntervalCyclic

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
