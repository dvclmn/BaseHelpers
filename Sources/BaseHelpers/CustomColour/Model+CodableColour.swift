//
//  Model+CodableColour.swift
//  Colour Library
//
//  Created by Dave Coleman on 3/9/2025.
//

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
public struct CodableColour: Sendable, Codable {
  var resolved: Color.Resolved
  var name: String?
  
  private static let colourSpace: Color.RGBColorSpace = .sRGB
  
  public init(
    resolved: Color.Resolved,
    name: String? = nil
  ) {
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
}

extension CodableColour {

  var colour: Color { Color(resolved) }
  
  mutating func setResolved(
    _ colour: Color,
    environment: EnvironmentValues?
  ) {
    resolved = colour.resolve(in: Self.environmentOrDefault(environment))
  }
  
  private static func environmentOrDefault(_ env: EnvironmentValues?) -> EnvironmentValues {
    env ?? EnvironmentValues()
  }
}
