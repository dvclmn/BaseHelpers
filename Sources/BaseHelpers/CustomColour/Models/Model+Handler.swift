//
//  Model+Handler.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/6/2025.
//

import SwiftUI

public protocol ColourHandlerProtocol {
  var activeColourLevel: ColourLevel { get set }
  //  public var focusedColourLevel: ColourLevel? = nil
  //  public var hoveredColourLevel: ColourLevel? = nil
  var foregroundRGB: RGBColour { get set }
  var backgroundRGB: RGBColour { get set }
  
  var foregroundHSB: HSBColour { get }
  var backgroundHSB: HSBColour { get }
  
  var foreground: Color { get }
  var background: Color { get }
}

extension ColourHandlerProtocol {
  
  public var foregroundHSB: HSBColour {
    HSBColour(fromRGB: foregroundRGB)
  }
  public var backgroundHSB: HSBColour {
    HSBColour(fromRGB: backgroundRGB)
  }
}
