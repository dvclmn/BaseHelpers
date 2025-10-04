//
//  SeparatorType.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/10/2025.
//

import Foundation

public enum SeparatorType {
  public static let defaultBuilderElement: String = "\n"
  public static let defaultComponent: String = " × "
  public static let defaultPropertyLabel: String = ": "
  
  /// Seperates elements from a result builder
  /// E.g. often `"\n"`, but can be anything
  case builderElement(String = Self.defaultBuilderElement)
  
  /// Seperates two (or more) `key-value` pairs
  /// E.g. the `" x "` from `800 x 600px`
  /// Or the `", "` from `X: 10, Y: -20`
  ///
  /// Who handles this separator?
  /// Whoever handles joining multiple `Component`s
  /// This is often a build expression?
  case component(String = Self.defaultComponent)
  
  /// Seperates the `key` from the `value`
  /// E.g. the `", "` from `X: 10, Y: -20`
  ///
  /// Who handles this separator?
  /// The type that holds onto both a `PropertyLabel`
  /// and a `value: any StringConvertible`.
  /// This is often a single `Component`
  case propertyLabel(String = Self.defaultPropertyLabel)
  
  public var stringValue: String {
    switch self {
      case .builderElement(let string): string
      case .component(let string): string
      case .propertyLabel(let string): string
    }
  }
}
