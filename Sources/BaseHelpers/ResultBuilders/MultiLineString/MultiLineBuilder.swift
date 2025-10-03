//
//  MultiLineBuilder.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/10/2025.
//

import Foundation

@resultBuilder
public struct MultiLineBuilder {
  
  public static func buildBlock(
    _ components: StringConvertible...
  ) -> [String] {
    components.map { $0.stringValue }
  }
  
  public static func buildOptional(
    _ component: StringConvertible?
  ) -> [String] {
    component.map { [$0.stringValue] } ?? []
  }
  
  public static func buildEither(
    first component: StringConvertible
  ) -> [String] {
    [component.stringValue]
  }
  
  public static func buildEither(
    second component: StringConvertible
  ) -> [String] {
    [component.stringValue]
  }
  
  public static func buildArray(
    _ components: [[StringConvertible]]
  ) -> [String] {
    components.flatMap { $0.map { $0.stringValue } }
  }
}
