//
//  Model+Handler.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/6/2025.
//

import SwiftUI

public protocol ColourHandlerProtocol {
//  var activeColourLevel: ColourLevel { get set }
  //  public var focusedColourLevel: ColourLevel? = nil
  //  public var hoveredColourLevel: ColourLevel? = nil
  var foregroundRGB: RGBColour { get set }
  var backgroundRGB: RGBColour { get set }
  
//  var foregroundHSV: HSVColour { get }
//  var backgroundHSV: HSVColour { get }
  
  var foreground: Color { get }
  var background: Color { get }
}

//extension ColourHandlerProtocol {
//  
//  public var foregroundHSV: HSVColour {
//    HSVColour(fromRGB: foregroundRGB)
//  }
//  public var backgroundHSV: HSVColour {
//    HSVColour(fromRGB: backgroundRGB)
//  }
//}
