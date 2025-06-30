//
//  Model+Colours.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import SwiftUI

public protocol ColourModel {
//  var colourSpace: Color.RGBColorSpace { get }
  var componentRange: ClosedRange<Double> { get }
  var nativeColour: Color { get }
  var alpha: Double { get set }
//  var resolvedColor: Color.Resolved { get }
  mutating func opacity(_ opacity: Double)
  static func gray(_ brightness: Double, alpha: Double) -> Self
  
//  func converting<T: ColourModel>(to type: T.Type) -> T
//  static func from<T: ColourModel>(_ other: T) -> Self
//  init<T: ColourModel>(from other: T)
  
  var colourSpace: ColourSpace { get }
  
  init(resolved: Color.Resolved)
}

// MARK: - Extension methods
extension ColourModel {
  
  public mutating func opacity(_ opacity: Double) {
    self.alpha = opacity
  }
  
  public var componentRange: ClosedRange<Double> { 0...1 }
  
  /// Note: I found that using RBGLinear did *not* look right
  public var colourSpace: ColourSpace { .sRGB }
}

public enum ColourSpace: String, CaseIterable {
  case sRGB
  case sRGBLinear
  case displayP3
  
  var nativeColorSpace: Color.RGBColorSpace {
    switch self {
      case .sRGB: return .sRGB
      case .sRGBLinear: return .sRGBLinear
      case .displayP3: return .displayP3
    }
  }
}

//public enum ColourModelType: String {
//  case rgb
//  case hsv
//}

