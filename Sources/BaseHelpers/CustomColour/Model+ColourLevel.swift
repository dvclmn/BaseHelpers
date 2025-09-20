//
//  Model+ColourLevel.swift
//  Paperbark
//
//  Created by Dave Coleman on 29/6/2025.
//

import SwiftUI
//import BaseHelpers

public protocol ColourHandlerProtocol {
  var foregroundRGB: RGBColour { get set }
  var backgroundRGB: RGBColour { get set }

  var foreground: Color { get }
  var background: Color { get }
}

public enum ColourLevel: String, Sendable, Cyclable {
  public typealias Item = Self
  
  public static let defaultCase: ColourLevel = .foreground
  
  case foreground
  case background
  
  public func keyPathRGB<T: ColourHandlerProtocol>() -> WritableKeyPath<T, RGBColour> {
    switch self {
      case .foreground: \.foregroundRGB
      case .background: \.backgroundRGB
    }
  }
  //  public func keyPathHSV<T: ColourHandlerProtocol>() -> KeyPath<T, HSVColour> {
  //    switch self {
  //      case .foreground: \.foregroundHSV
  //      case .background: \.backgroundHSV
  //    }
  //  }
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
