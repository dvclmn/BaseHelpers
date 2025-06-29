//
//  Model+Colours.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import SwiftUI

public protocol ColourModel {
  var colourSpace: Color.RGBColorSpace { get }
  var componentRange: ClosedRange<Double> { get }
  func swiftUIColour(includesAlpha: Bool) -> Color
  init(resolved: Color.Resolved)
}
extension ColourModel {
  public var componentRange: ClosedRange<Double> { 0...1 }
  
  /// Note: I found that using RBGLinear did *not* look right
  public var colourSpace: Color.RGBColorSpace {
    .sRGB
  }
}

public enum ColourModelType: String {
  case linearRGB
  case hsb
}

public protocol ColourBindable {
  associatedtype Handler: ColourHandlerProtocol
  var colourHandler: Handler { get set }
  func binding(
    for component: any ColourComponent,
    env: EnvironmentValues
  ) -> Binding<Double>
}
