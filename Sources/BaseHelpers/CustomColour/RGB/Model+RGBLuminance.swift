//
//  Model+RGBLuminance.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 25/8/2025.
//

import Foundation

public enum LuminanceMethod: Sendable, Codable {
  case wcag  // Rec.709 coefficients, linearised sRGB
  case rec601  // Video standard
  case hsp  // Perceived brightness
  case cielab  // CIE L* lightness
}

extension RGBColour {
  public func toXYZ() -> XYZColour {
    // Step 1: Linearise sRGB
    let r = linearised(red)
    let g = linearised(green)
    let b = linearised(blue)

    // Step 2: Convert to XYZ (D65 white)
    let x = (0.4124564 * r) + (0.3575761 * g) + (0.1804375 * b)
    let y = (0.2126729 * r) + (0.7151522 * g) + (0.0721750 * b)
    let z = (0.0193339 * r) + (0.1191920 * g) + (0.9503041 * b)

    return XYZColour(x: x, y: y, z: z)
  }

  private func linearised(_ channel: Double) -> Double {
    channel <= 0.04045
      ? channel / 12.92
      : pow((channel + 0.055) / 1.055, 2.4)
  }

  public func luminanceThreshold(using method: LuminanceMethod) -> LuminanceThreshold {
    return LuminanceThreshold(from: self)

  }

  public func luminance(using method: LuminanceMethod = .wcag) -> Double {
    switch method {
      case .wcag:
        let r = linearised(red)
        let g = linearised(green)
        let b = linearised(blue)
        return (0.2126 * r + 0.7152 * g + 0.0722 * b).clamped(to: 0...1)

      case .rec601:
        let r = linearised(red)
        let g = linearised(green)
        let b = linearised(blue)
        return (0.299 * r + 0.587 * g + 0.114 * b).clamped(to: 0...1)

      case .hsp:
        // Works directly in gamma-encoded space
        return sqrt(0.299 * pow(red, 2) + 0.587 * pow(green, 2) + 0.114 * pow(blue, 2)).clamped(to: 0...1)

      case .cielab:
        /// This assumes input RGB is already in sRGB space. If your package later
        /// supports wide-gamut (Display P3, Rec. 2020), you’d use a different matrix.
        /// - For CIELAB, the result is in 0…1 by dividing`L*` by `100`.
        ///   If you want the raw `L*` `(0…100)`, skip the division.
        /// - `XYZColour` could be useful later if you want chromatic adaptation
        ///   or CIEDE2000 colour difference.
        let xyz = toXYZ()
        let y = xyz.y / 1.0  // Yn = 1.0 for D65 white

        let f: (Double) -> Double = { t in
          t > 0.008856 ? pow(t, 1.0 / 3.0) : (7.787 * t) + (16.0 / 116.0)
        }
        let L = (116 * f(y)) - 16
        return (L / 100).clamped(to: 0...1)

    //        let xyz = toXYZ() // you'd need to implement RGB→XYZ
    //        let y = xyz.y / 1.0 // assuming D65 white point, Yn = 1
    //        let f: (Double) -> Double = { t in
    //          t > 0.008856 ? pow(t, 1.0/3.0) : (7.787 * t) + (16.0 / 116.0)
    //        }
    //        let L = (116 * f(y)) - 16
    //        return (L / 100).clamped(to: 0...1)
    }
  }
}

public struct XYZColour: Sendable, Codable {
  public var x: Double
  public var y: Double
  public var z: Double
}
