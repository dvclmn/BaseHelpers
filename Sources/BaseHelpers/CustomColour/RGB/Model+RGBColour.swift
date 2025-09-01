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
  
  public var name: String?

  //  enum CodingKeys: String, CodingKey {
  //    case id, red, green, blue, alpha
  //  }

  public init(
    colour: Color,
    environment: EnvironmentValues,
    name: String?
  ) {
    let resolved = colour.resolve(in: environment)
    self.init(
      resolved: resolved,
      name: name ?? colour.colourName
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

  public init(
    red: Double,
    green: Double,
    blue: Double,
    alpha: Double = 1.0,
    name: String? = nil
  ) {
    self.id = UUID()
    self.red = red
    self.green = green
    self.blue = blue
    self.alpha = alpha
    self.name = name
  }
}

extension RGBColour {

  public var toHSV: HSVColour {
    HSVColour(fromRGB: self)
  }

  public var swiftUIColour: Color {
    Color(
      colourSpace,
      red: red,
      green: green,
      blue: blue,
      opacity: alpha
    )
  }

  public func contrastColour(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose = .legibility,
    chroma: ColourChroma = .standard,
  ) -> RGBColour {

    guard strength.adjustmentStrength > 0 else { return self }
    
    let hsvColour = HSVColour(fromRGB: self)
    let adjustment = HSVAdjustment.applyingModifiers(
      for: self,
      strength: strength,
      purpose: purpose,
      chroma: chroma
    )

    let adjustedHSV = hsvColour.applying(adjustment: adjustment)
    return adjustedHSV.toRGB
  }

  public func contrastColour(modification: ColourModification?) -> RGBColour {
    guard let modification else { return self }

    return self.contrastColour(
      strength: modification.strength,
      purpose: modification.purpose,
      chroma: modification.chroma
    )
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

  /// Create a color with specified brightness (0.0 to 1.0)
  public static func gray(
    _ brightness: Double,
    alpha: Double = 1.0,
//    name: String?
  ) -> RGBColour {
    return RGBColour(
      red: brightness,
      green: brightness,
      blue: brightness,
      alpha: alpha,
      name: nil
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
