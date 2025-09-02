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
  var id: String { get }
  var name: String { get }
//  var keyPath: WritableKeyPath<Model, Double> { get }

  func sliderTrackGradient(
    colour: Model
  ) -> LinearGradient
}

extension ColourComponent {
  public var id: String { self.name }
  public var name: String { rawValue.capitalized }
}
