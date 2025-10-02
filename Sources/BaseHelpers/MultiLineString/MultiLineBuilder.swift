//
//  MultiLineBuilder.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/10/2025.
//

import Foundation

@resultBuilder
struct MultiLineBuilder {
  
  static func buildBlock(_ components: StringConvertible...) -> [String] {
    components.map { $0.stringValue }
  }
  
  static func buildOptional(_ component: StringConvertible?) -> [String] {
    component.map { [$0.stringValue] } ?? []
  }
  
  static func buildEither(first component: StringConvertible) -> [String] {
    [component.stringValue]
  }
  
  static func buildEither(second component: StringConvertible) -> [String] {
    [component.stringValue]
  }
  
  static func buildArray(_ components: [[StringConvertible]]) -> [String] {
    components.flatMap { $0.map { $0.stringValue } }
  }
}
