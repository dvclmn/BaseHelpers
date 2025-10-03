//
//  SequenceBuilder.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/10/2025.
//

public typealias DisplayStringBuilder = SequenceBuilder<DisplayString.Component>
public typealias StringGroupBuilder = SequenceBuilder<StringConvertible>

@resultBuilder
public struct SequenceBuilder<Element> {
  public static func buildBlock(
    _ components: Element...
  ) -> [Element] {
    components
  }

  public static func buildOptional(
    _ component: [Element]?
  ) -> [Element] {
    component ?? []
  }

  public static func buildEither(
    first component: [Element]
  ) -> [Element] {
    component
  }

  public static func buildEither(
    second component: [Element]
  ) -> [Element] {
    component
  }

  public static func buildArray(
    _ components: [[Element]]
  ) -> [Element] {
    components.flatMap { $0 }
  }
}
