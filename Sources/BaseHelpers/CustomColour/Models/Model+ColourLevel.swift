//
//  Model+ColourLevel.swift
//  BaseComponents
//
//  Created by Dave Coleman on 18/6/2025.
//

import SwiftUI

public enum ColourLevel: String {
 
  case foreground
  case background
  
  public func keyPathRGB<T: ColourHandlerProtocol>() -> WritableKeyPath<T, RGBColour> {
    switch self {
      case .foreground: \.foregroundRGB
      case .background: \.backgroundRGB
    }
  }
  public func keyPathHSB<T: ColourHandlerProtocol>() -> KeyPath<T, HSBColour> {
    switch self {
      case .foreground: \.foregroundHSB
      case .background: \.backgroundHSB
    }
  }
  public func keyPathSwiftUI<T: ColourHandlerProtocol>() -> KeyPath<T, Color> {
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
