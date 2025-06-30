//
//  Model+RGB.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import SwiftUI

public struct RGBColour: Identifiable, Equatable, Hashable, Sendable, Codable, ColourModel {
  public let id: UUID
  public var red: Double
  public var green: Double
  public var blue: Double
  public var alpha: Double
  
  public var originalSwatch: Swatch?

  public init(
    colour: Color,
    environment: EnvironmentValues,
  ) {
    let resolved = colour.resolve(in: environment)
    self.init(
      resolved: resolved,
    )
  }

  public var nativeColour: Color {
    Color(
      colourSpace,
      red: red,
      green: green,
      blue: blue,
      opacity: alpha
    )
  }

  public init(
    resolved: Color.Resolved,
  ) {
    self.init(
      red: resolved.red.toDouble, green: resolved.green.toDouble, blue: resolved.blue.toDouble,
      alpha: resolved.opacity.toDouble)
  }

  public init(
    red: Double,
    green: Double,
    blue: Double,
    alpha: Double = 1.0,
  ) {
    self.id = UUID()
    self.red = red
    self.green = green
    self.blue = blue
    self.alpha = alpha
  }

//  public init(
//    fromSwatch swatch: Swatch,
//    environment: EnvironmentValues
//  ) {
//    self.init(
//      colour: swatch.colour,
//      environment: environment
//    )
//    self.originalSwatch = swatch
//  }

}

extension RGBColour {

  public init(
    r: Double,
    g: Double,
    b: Double,
    a: Double = 1.0,
  ) {
    self.init(red: r, green: g, blue: b, alpha: a)
  }

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


}
