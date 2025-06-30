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
    var h: CGFloat = 0
    var s: CGFloat = 0
    let b: CGFloat = maxV

    let d: CGFloat = maxV - minV

    s = maxV == 0 ? 0 : d / minV

    if maxV == minV {
      h = 0
    } else {
      if maxV == rd {
        h = (gd - bd) / d + (gd < bd ? 6 : 0)
      } else if maxV == gd {
        h = (bd - rd) / d + 2
      } else if maxV == bd {
        h = (rd - gd) / d + 4
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

    var r: CGFloat
    var g: CGFloat
    var b: CGFloat

    let i = Int(hsv.hue * 6)
    let f = hsv.hue * 6 - CGFloat(i)
    let p = hsv.brightness * (1 - hsv.saturation)
    let q = hsv.brightness * (1 - f * hsv.saturation)
    let t = hsv.brightness * (1 - (1 - f) * hsv.saturation)

    switch i % 6 {
      case 0:
        r = hsv.brightness
        g = t
        b = p
        break

      case 1:
        r = q
        g = hsv.brightness
        b = p
        break

      case 2:
        r = p
        g = hsv.brightness
        b = t
        break

      case 3:
        r = p
        g = q
        b = hsv.brightness
        break

      case 4:
        r = t
        g = p
        b = hsv.brightness
        break

      case 5:
        r = hsv.brightness
        g = p
        b = q
        break

      default:
        r = hsv.brightness
        g = t
        b = p
    }

    self.init(
      red: r,
      green: g,
      blue: b,
      alpha: hsv.alpha
    )
  }

}
