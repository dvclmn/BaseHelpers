//
//  HSV+Complementary.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 26/8/2025.
//

import Foundation

//extension HSVColour {
//
//  /// Returns the complementary color (180° hue shift)
//  public var complementary: HSVColour {
//    complementary(strength: 1.0)
//  }
//
//  /// Returns a complementary color with adjustable strength
//  /// - Parameter strength: How much to shift toward complementary (0.0 = no change, 1.0 = full complement)
//  public func complementary(strength: Double = 1.0) -> HSVColour {
//    let clampedStrength = strength.clamped(to: 0...1)
//    let hueShift = 0.5 * clampedStrength  // 0.5 = 180° shift
//
//    var newHue = hue + hueShift
//    if newHue > 1.0 {
//      newHue -= 1.0  // Wrap around
//    }
//
//    return HSVColour(
//      hue: newHue,
//      saturation: saturation,
//      brightness: brightness,
//      alpha: alpha,
//      name: self.name
//    )
//  }
//
//  /// Returns complementary color using HSVAdjustment for consistency with your existing API
////  public func complementary(
////    using adjustment: HSVAdjustment,
////    strength: Double = 1.0
////  ) -> HSVColour {
////    let baseComplement = complementary(strength: strength)
////
////    return HSVColour(
////      hue: adjustment.hue ?? baseComplement.hue,
////      saturation: adjustment.saturation ?? baseComplement.saturation,
////      brightness: adjustment.brightness ?? baseComplement.brightness,
////      alpha: baseComplement.alpha
////    )
////  }
//
//  //  public var complementary: HSVColour {
//  //    let adjustment = HSVAdjustment(self.hue, self.saturation, self.brightness)
//  //    var newHue = hue + 0.5
//  //    if newHue > 1.0 { newHue -= 1.0 }  // wrap around
//  //    return HSVColour(
//  //      hue: newHue,
//  //      saturation: saturation,
//  //      brightness: brightness,
//  //      alpha: alpha)
//  //  }
//
//  /// Returns an array of analogous colors (adjacent hues)
//  /// - Parameters:
//  ///   - count: Number of analogous colors to generate (default: 2)
//  ///   - spacing: Hue spacing between colors in degrees (default: 30°)
//  public func analogous(
//    count: Int = 2,
//    spacingDegrees spacing: Double = 30
//  ) -> [HSVColour] {
//    let hueSpacing = spacing / 360.0  // Convert degrees to 0-1 range
//    var colors: [HSVColour] = []
//
//    for i in 1...count {
//      let offset = hueSpacing * Double(i)
//      var newHue = hue + offset
//      if newHue > 1.0 { newHue -= 1.0 }
//
//      colors.append(
//        HSVColour(
//          hue: newHue,
//          saturation: saturation,
//          brightness: brightness,
//          alpha: alpha,
//        ))
//    }
//
//    return colors
//  }
//
//  /// Returns a triadic color scheme (120° apart)
//  public var triadic: [HSVColour] {
//    let spacing = 1.0 / 3.0  // 120° in 0-1 range
//
//    let second = HSVColour(
//      hue: (hue + spacing).truncatingRemainder(dividingBy: 1.0),
//      saturation: saturation,
//      brightness: brightness,
//      alpha: alpha
//    )
//
//    let third = HSVColour(
//      hue: (hue + spacing * 2).truncatingRemainder(dividingBy: 1.0),
//      saturation: saturation,
//      brightness: brightness,
//      alpha: alpha
//    )
//
//    return [second, third]
//  }
//
//  /// Returns a split-complementary color scheme
//  public var splitComplementary: [HSVColour] {
//    let baseComplement = hue + 0.5
//    let adjustment = 1.0 / 12.0  // 30° in 0-1 range
//
//    let first = HSVColour(
//      hue: (baseComplement - adjustment).truncatingRemainder(dividingBy: 1.0),
//      saturation: saturation,
//      brightness: brightness,
//      alpha: alpha
//    )
//
//    let second = HSVColour(
//      hue: (baseComplement + adjustment).truncatingRemainder(dividingBy: 1.0),
//      saturation: saturation,
//      brightness: brightness,
//      alpha: alpha
//    )
//
//    return [first, second]
//  }
//}
//
//// MARK: - RGB
//extension RGBColour {
//  /// Returns the complementary color (180° hue shift)
//  public var complementary: RGBColour {
//    complementary(strength: 1.0)
//  }
//
//  /// Returns a complementary color with adjustable strength
//  /// - Parameter strength: How much to shift toward
//  ///   complementary (0.0 = no change, 1.0 = full complement)
//  public func complementary(
//    strength: Double = 1.0
//  ) -> RGBColour {
//    let hsvColor = HSVColour(fromRGB: self)
//    let complementaryHSV = hsvColor.complementary(strength: strength)
//    let complementaryRGB = RGBColour(fromHSV: complementaryHSV)
//    return complementaryRGB
//  }
//
//}
