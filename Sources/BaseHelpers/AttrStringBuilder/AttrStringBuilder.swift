//
//  AttrStringBuilder.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 6/7/2025.
//

import Foundation
import SwiftUI

// MARK: - @AttrString function builder attribute
@resultBuilder
public struct AttrString {
  public static func buildBlock(_ components: AttributedString...) -> AttributedString {
    components.reduce(AttributedString(), +)
  }

  public static func buildArray(_ components: [AttributedString]) -> AttributedString {
    components.reduce(AttributedString(), +)
  }

  public static func buildOptional(_ component: AttributedString?) -> AttributedString {
    component ?? AttributedString()
  }

  public static func buildEither(first component: AttributedString) -> AttributedString {
    component
  }

  public static func buildEither(second component: AttributedString) -> AttributedString {
    component
  }

  public static func buildExpression(_ expression: AttributedString) -> AttributedString {
    expression
  }

  public static func buildExpression(_ expression: String) -> AttributedString {
    AttributedString(expression)
  }
}

// MARK: - StyledText typealias and extensions
typealias StyledText = AttributedString

extension AttributedString {
  public init(@AttrString _ content: () -> AttributedString) {
    self = content()
  }

  // Fluent styling methods
  public func colour(_ colour: Color) -> AttributedString {
    var result = self
    result.foregroundColor = colour
    return result
  }

  public func fontStyle(_ font: Font) -> AttributedString {
    var result = self
    result.font = font
    return result
  }

  public func bold() -> AttributedString {
    var result = self
    result.inlinePresentationIntent = .stronglyEmphasized
    return result
  }

  public func italic() -> AttributedString {
    var result = self
    result.inlinePresentationIntent = .emphasized
    return result
  }

  public func underline() -> AttributedString {
    var result = self
    result.underlineStyle = .single
    return result
  }

  public func strikethrough() -> AttributedString {
    var result = self
    result.strikethroughStyle = .single
    return result
  }

  public func background(_ colour: Color) -> AttributedString {
    var result = self
    result.backgroundColor = colour
    return result
  }
}

// MARK: - Example Protocol and Usage
//protocol FloatPair {
//  var valueA: Double { get }
//  var valueB: Double { get }
//}
//
//extension FloatPair {
//  var displayStringA: String { String(format: "%.0f", valueA) }
//  var displayStringB: String { String(format: "%.0f", valueB) }
//}
//
//struct ExampleFloatPair: FloatPair {
//  let valueA: Double
//  let valueB: Double
//}

// MARK: - DSL Functions
@AttrString
public func valuePair(
  _ value: any FloatPair,
  decimalPlaces: Int = 2,
  separator: String = "x"
) -> AttributedString {
  StyledText(value.valueA.displayString(decimalPlaces))
  StyledText(separator)
    .colour(.secondary)
    .bold()
  StyledText(value.valueB.displayString(decimalPlaces))
}

@AttrString
public func styledTitle(_ title: String, subtitle: String?) -> AttributedString {
  StyledText(title)
    //    .font(.title)
    .bold()

  if let subtitle {
    StyledText("\n")
    StyledText(subtitle)
      .fontStyle(.caption)
      .colour(.secondary)
  }
}

@AttrString
public func highlightedText(_ text: String, highlight: String) -> AttributedString {
  let parts = text.components(separatedBy: highlight)

  for (index, part) in parts.enumerated() {
    StyledText(part)

    if index < parts.count - 1 {
      StyledText(highlight)
        .background(.yellow)
        .bold()
    }
  }
}

// MARK: - Advanced Example with Loops

/// Usage:
/// `let list = bulletList(["First item", "Second item", "Third item"])`

@AttrString
public func bulletList(_ items: [String]) -> AttributedString {
  for (index, item) in items.enumerated() {
    StyledText("• ")
      .colour(.blue)
      .bold()

    StyledText(item)

    if index < items.count - 1 {
      StyledText("\n")
    }
  }
}

// MARK: - Usage Examples
//func exampleUsage() {
//  // Basic usage
//  let pair = ExampleFloatPair(valueA: 1290, valueB: 340)
//  let result1 = valuePair(pair)
//
//  // With custom separator
//  let result2 = valuePair(pair, separator: " × ")
//
//  // Title with subtitle
//  let result3 = styledTitle("Main Title", subtitle: "Subtitle text")
//
//  // Title without subtitle
//  let result4 = styledTitle("Just Title", subtitle: nil)
//
//  // Complex styling
//  let result5 = AttributedString {
//    StyledText("Error: ")
//      .color(.red)
//      .bold()
//
//    StyledText("Something went wrong")
//      .color(.primary)
//
//    StyledText(" (Code: 404)")
//      .color(.secondary)
//      .font(.caption)
//  }
//
//  // Conditional content
//  let showDetails = true
//  let result6 = AttributedString {
//    StyledText("Base text")
//
//    if showDetails {
//      StyledText(" - with details")
//        .color(.blue)
//    }
//  }
//}
