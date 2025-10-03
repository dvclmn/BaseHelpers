//
//  Conversions.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/6/2025.
//

import Foundation

extension HSVColour {

  public init(fromRGB r: Double, g: Double, b: Double, a: Double, name: String?) {
    
    let red: Double = r
    let green: Double = g
    let blue: Double = b
    
    let maxV: Double = max(red, max(green, blue))
    let minV: Double = min(red, min(green, blue))
    let delta: Double = maxV - minV
    
    var h: Double = 0
    var s: Double = 0
    let b: Double = maxV
    
    s = (maxV == 0) ? 0 : (delta / maxV)
    
    if maxV == minV {
      h = 0
    } else {
      if maxV == red {
        h = (green - blue) / delta + (green < blue ? 6 : 0)
      } else if maxV == green {
        h = (blue - red) / delta + 2
      } else if maxV == blue {
        h = (red - green) / delta + 4
      }
      
      h /= 6
    }
    
    self.init(
      hue: h,
      saturation: s,
      brightness: b,
      alpha: a,
      name: name
    )
    
  }
  public init(fromRGB rgb: RGBColour) {
    self.init(
      fromRGB: rgb.red.value,
      g: rgb.green.value,
      b: rgb.blue.value,
      a: rgb.alpha.value,
      name: rgb.name
    )
  }
  
//  public init(fromRGB rgb: RGBColour) {
//
//    let rd: CGFloat = rgb.red.value
//    let gd: CGFloat = rgb.green.value
//    let bd: CGFloat = rgb.blue.value
//
//    let maxV: CGFloat = max(rd, max(gd, bd))
//    let minV: CGFloat = min(rd, min(gd, bd))
//    let delta: CGFloat = maxV - minV
//
//    var h: CGFloat = 0
//    var s: CGFloat = 0
//    let b: CGFloat = maxV
//
//    s = (maxV == 0) ? 0 : (delta / maxV)
//
//    if maxV == minV {
//      h = 0
//    } else {
//      if maxV == rd {
//        h = (gd - bd) / delta + (gd < bd ? 6 : 0)
//      } else if maxV == gd {
//        h = (bd - rd) / delta + 2
//      } else if maxV == bd {
//        h = (rd - gd) / delta + 4
//      }
//
//      h /= 6
//    }
//
//    self.init(
//      hue: h,
//      saturation: s,
//      brightness: b,
//      alpha: rgb.alpha.value,
//      name: rgb.name
//    )
//
//  }

}

extension RGBColour {

  public init(fromHSV hsv: HSVColour) {
    /// Normalize hue to `[0, 1]` range, handling negative values
    /// Older version, not sure which is better:
    /// `let h = hsv.hue - floor(hsv.hue)`
    let h = hsv.hue.value.truncatingRemainder(dividingBy: 1.0)
    let s = hsv.saturation.value
    let v = hsv.brightness.value

    /// Early exit for grayscale (no saturation)
    guard s.value > 0 else {
      self.init(red: v, green: v, blue: v, alpha: hsv.alpha.value, name: hsv.name)
      return
    }

    /// Calculate hue segment and fractional part
    let hueScaled = h * 6

    /// Ensures 0-5 range
    let hueSegment = Int(hueScaled) % 6
    let f = hueScaled - floor(hueScaled)

    /// Calculate intermediate values
    let p = v * (1 - s)
    let q = v * (1 - f * s)
    let t = v * (1 - (1 - f) * s)

    let (r, g, b): (Double, Double, Double)

    switch hueSegment {
      /// Red to Yellow
      case 0: (r, g, b) = (v, t, p)

      /// Yellow to Green
      case 1: (r, g, b) = (q, v, p)

      /// Green to Cyan
      case 2: (r, g, b) = (p, v, t)

      /// Cyan to Blue
      case 3: (r, g, b) = (p, q, v)

      /// Blue to Magenta
      case 4: (r, g, b) = (t, p, v)

      /// Magenta to Red
      case 5: (r, g, b) = (v, p, q)

      /// Fallback (shouldn't occur)
      default: (r, g, b) = (v, v, v)
    }
    self.init(r: r, g: g, b: b, a: hsv.alpha.value, name: hsv.name)
  }
}
