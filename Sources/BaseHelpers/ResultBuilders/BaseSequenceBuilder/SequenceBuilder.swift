//
//  SequenceBuilder.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/10/2025.
//

public typealias DisplayStringBuilder = SequenceBuilder<StringConvertible>
//public typealias StringGroupBuilder = SequenceBuilder<StringConvertible>

/// Good to remember:
/// The `{Example}Builder` (the type decorated directly with
/// `@resultBuilder`), is not the right place to have various
/// parameters passed in, like a function would.
///
/// The place for this is on the *function or type* that *uses*
/// the builder. Such as the below `DisplayString`.
///
/// It accepts a parameter, `separator`, making this type
/// the place that can be configured. Not the builder itself.
/// ```
/// public struct DisplayString {
///   let content: [any StringConvertible]
///   let separator: String
///
///   public init(
///     separator: String = .defaultComponentSeparator,
///     @DisplayStringBuilder _ content: () -> [any StringConvertible]
///   ) {
///     self.separator = separator
///     self.content = content()
///   }
/// }
/// ```

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

extension SequenceBuilder where Element: FloatDisplay {
  public static func buildExpression(
    _ expression: Element
  ) -> [StringConvertible] {
    [expression.displayString(<#T##places: DecimalPlaces##DecimalPlaces#>, grouping: <#T##Grouping#>)]
  }
}

