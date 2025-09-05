//
//  Model+ColourComponent.swift
//  BaseComponents
//
//  Created by Dave Coleman on 14/6/2025.
//

import SwiftUI

/// Important note: At one point, I tried pivoting from using an
/// enum (e.g. `HSVComponent`), to seperate per-component
/// structs (e.g. `RedComponent`, `HueComponent`).
///
/// I ended up back with enums, and much better off for it.
public protocol ColourComponent: Identifiable, Sendable, CaseIterable, RawRepresentable where RawValue == String {

  associatedtype Model: ColourModel
//  associatedtype ComponentValue: BinaryFloatingPoint
  var id: String { get }
  var name: String { get }
  var nameInitial: Character { get }
  
  /// ```
  /// var hsv = HSVColour(
  ///   hue: 0.1,
  ///   saturation: 0.5,
  ///   brightness: 0.8,
  ///   alpha: 1.0,
  ///   name: nil
  /// )
  /// let component = HSVComponent.hue
  ///
  /// print(component.get(hsv)) // 0.1
  /// component.set(&hsv, 0.3)
  /// ```
  var get: (_ model: Model) -> Double { get }
  var set: (_ model: inout Model, _ newValue: Double) -> Void { get }
  
//  func componentBinding(_ component: Self) -> Binding<Double>

  func sliderTrackGradient(colour: Model) -> LinearGradient
}

extension ColourComponent {
  public var id: String { self.name }
  public var name: String { rawValue.capitalized }
  
//  public func componentBinding(
//    _ component: Self,
//  ) -> Binding<Double> {
//    Binding {
//      component.get(model)
//    } set: { newValue in
//      component.set(&model, newValue)
//    }
//
////    .init(
////      get: { component.get($0) },
////      set: { component.set(&$0, $1) }
////    )
//  }
}
