//
//  ColourHandler.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import BaseHelpers
import SwiftUI

public enum ColourBorderBrightness {
  case dark
  case light

  public init(from luminance: Double) {
    self = luminance > 0.86 ? .dark : .light
  }
}

extension EnvironmentValues {
  @Entry public var colourHandler: ColourHandler = .init()
}

public struct ColourHandler: ColourHandlerProtocol, Sendable {

  /// This describes which colour is currently being used for drawing
  public var activeColourLevel: ColourLevel = .foreground
  /// This is when a user directly clicks a colour, and is editing it
  public var focusedColourLevel: ColourLevel? = nil
  public var hoveredColourLevel: ColourLevel? = nil

  /// This is the current, user-selected colour (there may be another
  /// introduced, so becoming foreground and background).
  public var foregroundRGB: RGBColour = .brown
  public var backgroundRGB: RGBColour = .orange

  public init() {}
  /// When changing HSV, update the canonical RGBA
  //  func update(fromHSV hsv: HSVColour) {
  //    let result = RGBColour(fromHSV: hsv)
  //    self.linearRGBA = result
  //  }

}

extension ColourHandler {

  //  public func rgbSwiftUIColour(for level: ColourLevel) -> Color {
  //    switch level {
  //      case .foreground: foregroundRGB.swiftUIColour
  //      case .background: backgroundRGB.swiftUIColour
  //    }
  //  }
  //  public func contrastingSwiftUIColour(
  //    for level: ColourLevel,
  //    withPreset preset: ContrastPreset = .standard,
  //  ) -> Color {
  //    switch level {
  //      case .foreground: foregroundRGB.contrastColour(withPreset: preset).swiftUIColour
  //      case .background: backgroundRGB.contrastColour(withPreset: preset).swiftUIColour
  //    }
  //  }

  //  public func isShowingSwappable(_ isHovering: Bool) -> Bool {
  //    isHovering && modifierKeys.contains(.option)
  //  }

  public var selectedColourBorderBrightness: ColourBorderBrightness {
    return ColourBorderBrightness(from: selectedColour.luminance())
  }

  public var foreground: Color {
    foregroundRGB.swiftUIColour
  }
  public var background: Color {
    backgroundRGB.swiftUIColour
  }
  //  public var foregroundHSV: HSVColour {
  //    HSVColour(fromRGB: foregroundRGB)
  //  }
  //  public var backgroundHSV: HSVColour {
  //    HSVColour(fromRGB: backgroundRGB)
  //  }

  public var selectedColour: RGBColour {
    switch activeColourLevel {
      case .foreground:
        return foregroundRGB
      case .background:
        return backgroundRGB
    }
  }

  public mutating func swapColours() {
    activeColourLevel.moveForward()
  }
}
