//
//  Model+CodableColour.swift
//  Colour Library
//
//  Created by Dave Coleman on 3/9/2025.
//

/// `Color` can *take in* HSV values
/// `Color.Resolved` can *give* only RGB

import SwiftUI

//public protocol CodableColour {
//  var resolved: Color.Resolved { get set }
//  var name: String? { get set }
//  var colour: Color { get }
//  
//  mutating func setResolved(
//    _ colour: Color,
//    environment: EnvironmentValues?
//  )
//  func environmentOrDefault(_ env: EnvironmentValues?) -> EnvironmentValues
//}

public struct CodableColour: Sendable, Codable, Identifiable {
  public let id: UUID
  public var resolved: Color.Resolved
  public var name: String?
  public var nameWithFallback: String { name ?? "Unknown" }
  
  private static let colourSpace: Color.RGBColorSpace = .sRGB
  
  public init(
    fromColor color: Color,
    env: EnvironmentValues?,
    name: String? = nil
  ) {
    self.init(resolved: color.resolve(in: Self.environmentOrDefault(env)), name: name)
  }
  
  public init(
    resolved: Color.Resolved,
    name: String? = nil
  ) {
    self.id = UUID()
    self.resolved = resolved
    self.name = name
  }
  
  public init(
    r: Double,
    g: Double,
    b: Double,
    a: Double = 1,
    name: String? = nil
  ) {
    let resolved = Color.Resolved(
      colorSpace: Self.colourSpace,
      red: r.toFloat,
      green: g.toFloat,
      blue: b.toFloat,
      opacity: a.toFloat
    )
    self.init(resolved: resolved, name: name)
  }
  
  public init(fromHSV hsv: HSVColour, env: EnvironmentValues?) {
    let colourRep = hsv.swiftUIColour
    self.init(
      resolved: colourRep.resolve(in: Self.environmentOrDefault(env)),
      name: hsv.name
    )
  }
}

extension CodableColour {

  public var colour: Color { Color(resolved) }
  
  public var toHSV: HSVColour {
    return HSVColour(
      fromRGB: resolved.red.toDouble,
      g: resolved.green.toDouble,
      b: resolved.blue.toDouble,
      a: resolved.opacity.toDouble,
      name: name
    )
  }
  
  public mutating func setResolved(
    _ colour: Color,
    environment: EnvironmentValues?
  ) {
    resolved = colour.resolve(in: Self.environmentOrDefault(environment))
  }
  
  public static func environmentOrDefault(_ env: EnvironmentValues?) -> EnvironmentValues {
    env ?? EnvironmentValues()
  }
  
  /// Returns `self` if no mod provided
  public func contrastColour(
    _ modification: ColourModification?,
    _ env: EnvironmentValues?
  ) -> Self {
    guard let modification else { return self }
    let modified = toHSV.contrastColour(modification: modification)
    return CodableColour(fromHSV: modified, env: env)
  }
  
  public func contrastColour(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose = .legibility,
    chroma: ColourChroma = .standard,
    environment: EnvironmentValues?
  ) -> Self {
//    guard let modification else { return self }
    let modified = toHSV.contrastColour(
      strength: strength,
      purpose: purpose,
      chroma: chroma
    )
    return CodableColour(fromHSV: modified, env: environment)
  }
  
//  func applying(adjustment: HSVAdjustment) -> HSVColour {
//    
//    let hsv = self.toHSV
//    let adjustedHue = adjustment.hue.map { hsv.hue + $0 } ?? hsv.hue
//    
//    let adjustedSaturation =
//    adjustment.saturation.map { hsv.saturation + $0 } ?? hsv.saturation
//    
//    let adjustedBrightness =
//    adjustment.brightness.map { hsv.brightness + $0 } ?? hsv.brightness
//    
//    return HSVColour(
//      hueCyclic: adjustedHue,
//      saturation: adjustedSaturation,
//      brightness: adjustedBrightness,
//      alpha: hsv.alpha,
//      name: self.name
//    )
//  }
}

//extension HSVColour {
//  init(fromCodable colour: CodableColour)
//}
