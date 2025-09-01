//
//  Conversions.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/6/2025.
//

import Foundation

extension HSVColour {

  public init(
    fromRGB rgb: RGBColour,
//    name: String?
  ) {

    let rd: CGFloat = rgb.red
    let gd: CGFloat = rgb.green
    let bd: CGFloat = rgb.blue

    let maxV: CGFloat = max(rd, max(gd, bd))
    let minV: CGFloat = min(rd, min(gd, bd))
    let delta: CGFloat = maxV - minV

    var h: CGFloat = 0
    var s: CGFloat = 0
    let b: CGFloat = maxV

    s = (maxV == 0) ? 0 : (delta / maxV)

    if maxV == minV {
      h = 0
    } else {
      if maxV == rd {
        h = (gd - bd) / delta + (gd < bd ? 6 : 0)
      } else if maxV == gd {
        h = (bd - rd) / delta + 2
      } else if maxV == bd {
        h = (rd - gd) / delta + 4
      }

      h /= 6
    }

    self.init(
      hue: h,
      saturation: s,
      brightness: b,
      alpha: rgb.alpha,
      name: rgb.name
    )
  }

}

extension RGBColour {

  public init(
    fromHSV hsv: HSVColour,
//    name: String?
  ) {
    /// Normalize hue to `[0, 1]` range, handling negative values
    /// Older version, not sure which is better:
    /// `let h = hsv.hue - floor(hsv.hue)`
    let h = hsv.hue.truncatingRemainder(dividingBy: 1.0)
    let s = hsv.saturation
    let v = hsv.brightness

    /// Early exit for grayscale (no saturation)
    guard s > 0 else {
      self.init(
        red: v,
        green: v,
        blue: v,
        alpha: hsv.alpha,
        name: hsv.name
      )
      return
    }

    /// Calculate hue segment and fractional part
    let hueScaled = h * 6
    let hueSegment = Int(hueScaled) % 6  // Ensures 0-5 range
    let f = hueScaled - floor(hueScaled)

    /// Calculate intermediate values
    let p = v * (1 - s)
    let q = v * (1 - f * s)
    let t = v * (1 - (1 - f) * s)

    let (r, g, b): (Double, Double, Double)

    switch hueSegment {
      case 0: (r, g, b) = (v, t, p)  // Red to Yellow
      case 1: (r, g, b) = (q, v, p)  // Yellow to Green
      case 2: (r, g, b) = (p, v, t)  // Green to Cyan
      case 3: (r, g, b) = (p, q, v)  // Cyan to Blue
      case 4: (r, g, b) = (t, p, v)  // Blue to Magenta
      case 5: (r, g, b) = (v, p, q)  // Magenta to Red
      default: (r, g, b) = (v, v, v)  // Fallback (shouldn't occur)
    }

    self.init(
      red: r.clamped(to: 0...1),
      green: g.clamped(to: 0...1),
      blue: b.clamped(to: 0...1),
      alpha: hsv.alpha,
      name: hsv.name
    )
  }
}
