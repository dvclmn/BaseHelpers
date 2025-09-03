//
//  Model+RGB.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import SwiftUI

public struct RGBColour: Identifiable, Equatable, Hashable, Sendable, Codable, ColourModel {
  public let id: UUID
  public var red: UnitInterval
  public var green: UnitInterval
  public var blue: UnitInterval
  public var alpha: UnitInterval

  public var name: String?

  public init(
    red: Double,
    green: Double,
    blue: Double,
    alpha: Double = 1.0,
    name: String? = nil
  ) {
    self.init(
      unitInterval: red.toUnitInterval,
      green.toUnitInterval,
      blue.toUnitInterval,
      alpha.toUnitInterval,
      name: name
    )
  }
  public init(
    unitInterval red: UnitInterval,
    _ green: UnitInterval,
    _ blue: UnitInterval,
    _ alpha: UnitInterval = 1.0,
    name: String? = nil
  ) {
    self.id = UUID()
    self.red = red
    self.green = green
    self.blue = blue
    self.alpha = alpha
    self.name = name
  }

  public init(
    r: Double,
    g: Double,
    b: Double,
    a: Double = 1.0,
    name: String?
  ) {
    self.init(red: r, green: g, blue: b, alpha: a, name: name)
  }

  public init(
    colour: Color,
    environment: EnvironmentValues,
    name: String?
  ) {
    let resolved = colour.resolve(in: environment)
    self.init(
      resolved: resolved,
      name: name
//      name: name ?? colour.colourName
    )
  }

  public init(
    resolved: Color.Resolved,
    name: String?
  ) {
    self.init(
      red: resolved.red.toDouble,
      green: resolved.green.toDouble,
      blue: resolved.blue.toDouble,
      alpha: resolved.opacity.toDouble,
      name: name
    )
  }
}

extension RGBColour {

  public var toHSV: HSVColour { HSVColour(fromRGB: self) }

  public var swiftUIColour: Color {
    Color(
      colourSpace,
      red: red.value,
      green: green.value,
      blue: blue.value,
      opacity: alpha.value
    )
  }

  /// Create a color with specified brightness (0.0 to 1.0)
  public static func gray(
    _ brightness: Double,
    alpha: Double = 1.0,
  ) -> RGBColour {
    return RGBColour(
      red: brightness,
      green: brightness,
      blue: brightness,
      alpha: alpha,
      name: "Gray"
    )
  }
}

extension RGBColour: CustomStringConvertible {
  public var description: String {
    let result = """
      RGBColour[R: \(self.red), G: \(self.green), B: \(self.blue), Name: \(name ?? "nil")]
      """

    return result
  }
}
