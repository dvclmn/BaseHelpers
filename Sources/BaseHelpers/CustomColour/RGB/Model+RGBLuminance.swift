//
//  Model+RGBLuminance.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 25/8/2025.
//

public enum LuminanceMethod: Sendable, Codable {
  case wcag       // Rec.709 coefficients, linearised sRGB
  case rec601     // Video standard
  case hsp        // Perceived brightness
  case cielab     // CIE L* lightness
}

extension RGBColour {
  private func linearised(_ channel: Double) -> Double {
    channel <= 0.04045
    ? channel / 12.92
    : pow((channel + 0.055) / 1.055, 2.4)
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
        return sqrt(0.299 * pow(red, 2) +
                    0.587 * pow(green, 2) +
                    0.114 * pow(blue, 2)).clamped(to: 0...1)
        
      case .cielab:
        let xyz = toXYZ() // you'd need to implement RGB→XYZ
        let y = xyz.y / 1.0 // assuming D65 white point, Yn = 1
        let f: (Double) -> Double = { t in
          t > 0.008856 ? pow(t, 1.0/3.0) : (7.787 * t) + (16.0 / 116.0)
        }
        let L = (116 * f(y)) - 16
        return (L / 100).clamped(to: 0...1)
    }
  }
}
