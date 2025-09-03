//
//  File.swift
//
//
//  Created by Dave Coleman on 23/7/2024.
//

import NSUI
import SwiftUI

extension Color {

  public func toCodable(_ env: EnvironmentValues?) -> CodableColour {
    return CodableColour(fromColor: self, env: env)
  }
  
//  public var namedColour: NamedColour? {
//    return NamedColour.allCases.first { $0.colour.swiftUIColour == self }
//  }

//  public func complementary(
//    strength: Double = 1.0,
//    environment: EnvironmentValues
//  ) -> Color {
//
//    let hsvColour = HSVColour(colour: self, environment: environment, name: self.colourName)
//    let complementary = hsvColour.complementary(strength: strength)
//    return complementary.swiftUIColour
//  }

  public func mixCompatible(
    with rhs: Color,
    by fraction: Double,
    in colorSpace: Gradient.ColorSpace = .perceptual
  ) -> Color {
    guard #available(macOS 15, iOS 18, *) else {
      return self
    }
    return self.mix(
      with: rhs,
      by: fraction,
      in: colorSpace
    )
  }

  public var toShapeStyle: AnyShapeStyle { AnyShapeStyle(self) }
}

enum OpacityPreset: CGFloat {
  case opacityBarelyThere = 0.03
  case opacityFaint = 0.1
  case opacityLow = 0.3
  case opacityMid = 0.5
  case opacityMedium = 0.65
  case opacityHigh = 0.85
  case opacityNearOpaque = 0.9
}

extension Color {

  public var opacityBarelyThere: Color { opacity(OpacityPreset.opacityBarelyThere.rawValue) }
  public var opacityFaint: Color { opacity(OpacityPreset.opacityFaint.rawValue) }
  public var opacityLow: Color { opacity(OpacityPreset.opacityLow.rawValue) }
  public var opacityMid: Color { opacity(OpacityPreset.opacityMid.rawValue) }
  public var opacityMedium: Color { opacity(OpacityPreset.opacityMedium.rawValue) }
  public var opacityHigh: Color { opacity(OpacityPreset.opacityHigh.rawValue) }
  public var opacityNearOpaque: Color { opacity(OpacityPreset.opacityNearOpaque.rawValue) }

  public static var random: Color { self.random() }

  public static func random(randomOpacity: Bool = false) -> Color {
    Color(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1),
      opacity: randomOpacity ? .random(in: 0...1) : 1
    )
  }
  public var toNSColour: NSUIColor { NSUIColor(self) }
}

extension Array where Element == Color {
  public static let rainbow: [Color] = [
    .red, .orange, .yellow, .green, .blue, .indigo, .purple, .pink, .red,
  ]
}
