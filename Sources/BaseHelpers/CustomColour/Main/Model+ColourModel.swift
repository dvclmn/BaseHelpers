//
//  Model+Colours.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import SwiftUI

public protocol ColourModel {
  var colourSpace: Color.RGBColorSpace { get }
  var nativeColour: Color { get }
  var alpha: Double { get set }
  mutating func opacity(_ opacity: Double)
  static func gray(_ brightness: Double, alpha: Double) -> Self
  init(resolved: Color.Resolved)
}

// MARK: - Extension methods
extension ColourModel {
  
  public mutating func opacity(_ opacity: Double) {
    self.alpha = opacity
  }
  
  public var colourSpace: Color.RGBColorSpace { .sRGB }
}

//public enum ColourSpace: String, CaseIterable {
//  case sRGB
//  case sRGBLinear
//  case displayP3
//  
//  var nativeColorSpace: Color.RGBColorSpace {
//    switch self {
//      case .sRGB: return .sRGB
//      case .sRGBLinear: return .sRGBLinear
//      case .displayP3: return .displayP3
//    }
//  }
//}

//public enum ColourModelType: String {
//  case rgb
//  case hsv
//}

