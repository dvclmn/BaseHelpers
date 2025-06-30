//
//  Model+RGB.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import SwiftUI

public struct RGBColour: Identifiable, Equatable, Hashable, Sendable, Codable, ColourModel {
  public let id: UUID
  private var resolved: Color.Resolved

  public var red: Double {
    get { resolved.red.toDouble }
    set {
      resolved = Color.Resolved(
        red: newValue.toFloat,
        green: resolved.green,
        blue: resolved.blue,
        opacity: resolved.opacity
      )
    }
  }

  public var green: Double {
    get { resolved.green.toDouble }
    set {
      resolved = Color.Resolved(
        red: resolved.red,
        green: newValue.toFloat,
        blue: resolved.blue,
        opacity: resolved.opacity
      )
    }
  }

  public var blue: Double {
    get { resolved.blue.toDouble }
    set {
      resolved = Color.Resolved(
        red: resolved.red,
        green: resolved.green,
        blue: newValue.toFloat,
        opacity: resolved.opacity
      )
    }
  }

  public var alpha: Double {
    get { resolved.opacity.toDouble }
    set {
      resolved = Color.Resolved(
        red: resolved.red,
        green: resolved.green,
        blue: resolved.blue,
        opacity: newValue.toFloat
      )
    }
  }

  public var nativeColour: Color { Color(resolved) }

  //  public var red: Double
  //  public var green: Double
  //  public var blue: Double
  //  public var alpha: Double

  public init(
    colour: Color,
    environment: EnvironmentValues,
  ) {
    let resolved = colour.resolve(in: environment)
    self.init(
      resolved: resolved,
    )
  }

  //  public init(
  //    r: Double,
  //    g: Double,
  //    b: Double,
  //    a: Double = 1.0,
  //
  //  ) {
  //    self.init(red: r, green: g, blue: b, alpha: a)
  //  }

//  public init(
//    gray: Double,
//    alpha: Double = 1.0,
//  ) {
//    self.init(red: gray, green: gray, blue: gray, alpha: alpha)
//  }

  public init(
    resolved: Color.Resolved,
  ) {
    self.id = UUID()
    self.resolved = resolved
//    self.init(
//      red: resolved.red.toDouble, green: resolved.green.toDouble, blue: resolved.blue.toDouble,
//      alpha: resolved.opacity.toDouble)
  }

  public init(
    red: Double,
    green: Double,
    blue: Double,
    alpha: Double = 1.0
  ) {
    self.id = UUID()
    self.resolved = Color.Resolved(
      red: red.clamped(to: 0...1).toFloat,
      green: green.clamped(to: 0...1).toFloat,
      blue: blue.clamped(to: 0...1).toFloat,
      opacity: alpha.clamped(to: 0...1).toFloat
    )
  }
  
//  public init(
//    red: Double,
//    green: Double,
//    blue: Double,
//    alpha: Double = 1.0,
//  ) {
//    self.id = UUID()
//    self.red = red
//    self.green = green
//    self.blue = blue
//    self.alpha = alpha
//  }

  public init(fromSwatch swatch: Swatch, environment: EnvironmentValues) {
    self.init(
      colour: swatch.colour,
      environment: environment
    )
  }
  
  public init(from hsv: HSVColour) {
    self = Self.from(hsv)
  }

}

extension RGBColour {
  
  public var resolvedColor: Color.Resolved { resolved }
  
  public func converting<T: ColourModel>(to type: T.Type) -> T {
    return T.from(self)
  }
  
  public static func from<T: ColourModel>(_ other: T) -> RGBColour {
    return RGBColour(resolved: other.resolvedColor)
  }

  //  public func converting

  //  public var nativeColour: Color {
  //    Color(
  //      colourSpace,
  //      red: red,
  //      green: green,
  //      blue: blue,
  //      opacity: alpha
  ////      opacity: 1.0
  ////      opacity: includesAlpha ? alpha : 1.0
  //    )
  //  }

  func linearised(_ channel: Double) -> Double {
    return channel <= 0.04045
      ? channel / 12.92
      : pow((channel + 0.055) / 1.055, 2.4)
  }

  public var luminance: Double {
    let r = linearised(red)
    let g = linearised(green)
    let b = linearised(blue)
    return (0.2126 * r + 0.7152 * g + 0.0722 * b).clamped(to: 0...1)
  }

  /// Create a color with specified brightness (0.0 to 1.0)
  public static func gray(_ brightness: Double, alpha: Double = 1.0) -> RGBColour {
    return RGBColour(
      red: brightness,
      green: brightness,
      blue: brightness,
      alpha: alpha
    )
  }

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
