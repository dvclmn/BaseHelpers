//
//  Model+ColourComponent.swift
//  BaseComponents
//
//  Created by Dave Coleman on 14/6/2025.
//

import SwiftUI

/// Important note: At one point, I tried pivoting from using an
/// enum (e.g. `HSBComponent`), to seperate per-component
/// structs (e.g. `RedComponent`, `HueComponent`).
///
/// I ended up back with enums, and was happier for it.
public protocol ColourComponent: Identifiable, Sendable, CaseIterable, RawRepresentable where RawValue == String {
  
  associatedtype Model: ColourModel
  var id: String { get }
  var name: String { get }
  var keyPath: WritableKeyPath<Model, Double> { get }
  var handlerKeyPathForeground: KeyPath<ColourHandlerProtocol, Model> { get }
  var handlerKeyPathBackground: KeyPath<ColourHandlerProtocol, Model> { get }

  func getValue(from model: Model) -> Double
  func trackGradient(
    colour: Model
  ) -> LinearGradient

}

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

extension ColourComponent {

  public var id: String { self.name }
  public var name: String { rawValue.capitalized }

  public func getValue(from model: Model) -> Double {
    return model[keyPath: keyPath]
  }
  
  
}

