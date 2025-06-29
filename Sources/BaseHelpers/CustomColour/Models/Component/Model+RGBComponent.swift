//
//  Model+Components.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import SwiftUI

//public enum RGBColourFromStatus {
//  case
//}

public enum RGBComponent: String, ColourComponent {

  public typealias Model = RGBColour

  case red
  case green
  case blue
  case alpha

  public var keyPath: WritableKeyPath<Model, Double> {
    switch self {
      case .red: \.red
      case .green: \.green
      case .blue: \.blue
      case .alpha: \.alpha
    }
  }

//  public var handlerKeyPathPickerColour: KeyPath<ColourHandler, Model> {
//    switch 
//    
//    \.foregroundRGB
//  }
  
  public var handlerKeyPathForeground: KeyPath<ColourHandlerProtocol, Model> {
    \.foregroundRGB
  }
  public var handlerKeyPathBackground: KeyPath<ColourHandlerProtocol, Model> {
    \.backgroundRGB
  }

  public func trackGradient(colour: RGBColour) -> LinearGradient {
    func makeColour(
      r: Double,
      g: Double,
      b: Double,
      opacity: Double = 1.0
    ) -> Color {
      Color(red: r, green: g, blue: b).opacity(opacity)
    }
    
    let (start, end): (Color, Color)
    
    switch self {
      case .red:
        start = makeColour(r: 0.0, g: colour.green, b: colour.blue)
        end = makeColour(r: 1.0, g: colour.green, b: colour.blue)
        
      case .green:
        start = makeColour(r: colour.red, g: 0.0, b: colour.blue)
        end = makeColour(r: colour.red, g: 1.0, b: colour.blue)
        
      case .blue:
        start = makeColour(r: colour.red, g: colour.green, b: 0.0)
        end = makeColour(r: colour.red, g: colour.green, b: 1.0)
        
      case .alpha:
        let base = makeColour(r: colour.red, g: colour.green, b: colour.blue)
        start = base.opacity(0.0)
        end = base.opacity(1.0)
    }
    
    return LinearGradient(colors: [start, end], startPoint: .leading, endPoint: .trailing)
  }
}
