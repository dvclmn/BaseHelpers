//
//  Model+ColourLevel.swift
//  BaseComponents
//
//  Created by Dave Coleman on 18/6/2025.
//

import SwiftUI

public enum ColourLevel: String, Cyclable {
  public static let defaultCase: ColourLevel = .foreground
  
  case foreground
  case background
  
  public var keyPathRGB: WritableKeyPath<ColourHandler, RGBColour> {
    switch self {
      case .foreground: \.foregroundRGB
      case .background: \.backgroundRGB
    }
  }
  public var keyPathHSB: KeyPath<ColourHandler, HSBColour> {
    switch self {
      case .foreground: \.foregroundHSB
      case .background: \.backgroundHSB
    }
  }
  public var keyPathSwiftUI: KeyPath<ColourHandler, Color> {
    switch self {
      case .foreground: \.foreground
      case .background: \.background
    }
  }
//  public var keyPathSelected: KeyPath<ColourHandler, Self> {
//    return \.activeColourLevel
//    //    switch self {
//    //      case .foreground:
//    //      case .background: \.background
//    //    }
//  }
  
  public var isForeground: Bool {
     return self == .foreground
  }
//  public func isSelected(_ handler: ColourHandler) -> Bool {
//    return self == handler[keyPath: keyPathSelected]
//  }
}
