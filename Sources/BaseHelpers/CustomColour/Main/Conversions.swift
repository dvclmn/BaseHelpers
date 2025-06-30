//
//  Conversions.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/6/2025.
//

import Foundation

extension HSVColour {

  public init(fromRGB rgb: RGBColour) {

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
      alpha: rgb.alpha
    )
  }

}

extension RGBColour {

  public init(fromHSV hsv: HSVColour) {
    /// Normalize hue to [0, 1) range, handling negative values
    let h = hsv.hue - floor(hsv.hue)
    let s = hsv.saturation
    let v = hsv.brightness
    
    /// Early exit for grayscale (no saturation)
    guard s > 0 else {
      self.init(red: v, green: v, blue: v, alpha: hsv.alpha)
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
      alpha: hsv.alpha
    )
  }
//  public init(fromHSV hsv: HSVColour) {
//
//    let r: CGFloat
//    let g: CGFloat
//    let b: CGFloat
//
//    let i = Int(hsv.hue * 6)
//    let f = hsv.hue * 6 - CGFloat(i)
//    let p = hsv.brightness * (1 - hsv.saturation)
//    let q = hsv.brightness * (1 - f * hsv.saturation)
//    let t = hsv.brightness * (1 - (1 - f) * hsv.saturation)
//
//    switch i % 6 {
//      case 0:
//        r = hsv.brightness
//        g = t
//        b = p
//        break
//
//      case 1:
//        r = q
//        g = hsv.brightness
//        b = p
//        break
//
//      case 2:
//        r = p
//        g = hsv.brightness
//        b = t
//        break
//
//      case 3:
//        r = p
//        g = q
//        b = hsv.brightness
//        break
//
//      case 4:
//        r = t
//        g = p
//        b = hsv.brightness
//        break
//
//      case 5:
//        r = hsv.brightness
//        g = p
//        b = q
//        break
//
//      default:
//        r = hsv.brightness
//        g = t
//        b = p
//    }
//
//    self.init(
//      red: r,
//      green: g,
//      blue: b,
//      alpha: hsv.alpha
//    )
//  }
  
  //  public func toHSV() -> HSVColour {
  //    let result = HSVColour(fromRGB: self)
  //    return result
  //  }
  
  //  public init(fromHSV hsv: HSVColour) {
  //
  //    let h = Self.normalisedHue(hsv.hue)
  //    let s = hsv.saturation
  //    let v = hsv.brightness
  //    let a = hsv.alpha
  //
  //    let c = v * s
  //    let x = c * (1 - abs((h * 6).truncatingRemainder(dividingBy: 2) - 1))
  //    let m = v - c
  //
  //    let hSegment = Int((h * 6).clamped(toIntRange: 0..<6))
  //
  //    let (r1, g1, b1): (Double, Double, Double)
  //
  //    switch hSegment {
  //      case 0: (r1, g1, b1) = (c, x, 0)
  //      case 1: (r1, g1, b1) = (x, c, 0)
  //      case 2: (r1, g1, b1) = (0, c, x)
  //      case 3: (r1, g1, b1) = (0, x, c)
  //      case 4: (r1, g1, b1) = (x, 0, c)
  //      case 5: (r1, g1, b1) = (c, 0, x)
  //      default: (r1, g1, b1) = (0, 0, 0)
  //    }
  //
  //    self.init(
  //      red: (r1 + m).clamped(to: 0...1),
  //      green: (g1 + m).clamped(to: 0...1),
  //      blue: (b1 + m).clamped(to: 0...1),
  //      alpha: a
  //    )
  //  }
  //
  //  static func normalisedHue(_ h: Double) -> Double {
  //    let wrapped = h.truncatingRemainder(dividingBy: 1)
  //    return wrapped < 0 ? wrapped + 1 : wrapped
  //  }

}
