//
//  Model+DisplayStringConfig.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/7/2025.
//

import Foundation

public enum DisplayLabelStyle: Equatable {
  case none
  case standard
  case abbreviated

  public var keyPath: KeyPath<PropertyLabel, String>? {
    switch self {
      case .none: nil
      case .standard: \.label
      case .abbreviated: \.abbreviated
    }
  }

  /// This will be composed together with float values
  /// within `DisplayString/formatted()`.
  /// Returning nil allows expressing "No label please"
  public func labelString(for component: Component) -> String? {
    guard let keyPath else { return nil }
    return component.label?[keyPath: keyPath]
  }
}
