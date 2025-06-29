//
//  Model+HSV.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import SwiftUI

public struct HSVColour: Equatable, Sendable, ColourModel {
  
  public var hue: Double
  public var saturation: Double
  public var brightness: Double
  public var alpha: Double

  public func nativeColour(includesAlpha: Bool = true) -> Color {
    Color(
      hue: hue,
      saturation: saturation,
      brightness: brightness,
      opacity: includesAlpha ? alpha : 1.0
    )
  }
  
  public init(
    hue: Double,
    saturation: Double,
    brightness: Double,
    alpha: Double
  ) {
    self.hue = hue
    self.saturation = saturation
    self.brightness = brightness
    self.alpha = alpha
  }
  
  public init(
    colour: Color,
    environment: EnvironmentValues
  ) {
    let resolved = colour.resolve(in: environment)
    self.init(resolved: resolved)
  }
  
  public init(resolved: Color.Resolved) {
    let rgba = RGBColour(resolved: resolved)
    self.init(fromRGB: rgba)
  }
}

extension HSVColour {
  
  func applying(adjustment: HSVAdjustment) -> HSVColour {
    var newHue = hue + (adjustment.hue / 360.0)
    if newHue < 0 { newHue += 1 }
    if newHue > 1 { newHue -= 1 }
    
    let newSaturation = (saturation + adjustment.saturation).clamped(to: 0...1)
    let newBrightness = (brightness + adjustment.brightness).clamped(to: 0...1)
    
    return HSVColour(
      hue: newHue,
      saturation: newSaturation,
      brightness: newBrightness,
      alpha: alpha
    )
  }
  
  public func toRGBA() -> RGBColour {
    let result = RGBColour(fromHSV: self)
    return result
  }

  public init(fromRGB rgba: RGBColour) {
    let r = rgba.red
    let g = rgba.green
    let b = rgba.blue
    let a = rgba.alpha
    
    let maxVal = max(r, g, b)
    let minVal = min(r, g, b)
    let delta = maxVal - minVal
    
    var h: Double = 0
    let s: Double = (maxVal == 0) ? 0 : (delta / maxVal)
    let v: Double = maxVal
    
    if delta != 0 {
      if maxVal == r {
        h = ((g - b) / delta).truncatingRemainder(dividingBy: 6)
      } else if maxVal == g {
        h = ((b - r) / delta) + 2
      } else {
        h = ((r - g) / delta) + 4
      }
      
      h /= 6
      if h < 0 { h += 1 }
    }
    
    self.init(
      hue: h,
      saturation: s.clamped(to: 0...1),
      brightness: v.clamped(to: 0...1),
      alpha: a
    )
  }
}
