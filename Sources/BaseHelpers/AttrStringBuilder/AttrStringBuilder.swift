//
//  AttrStringBuilder.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 6/7/2025.
//

import Foundation
import SwiftUI

// MARK: - Result Builder
//@resultBuilder
//struct AttrStringBuilder {
//  static func buildBlock(_ components: AttributedString...) -> AttributedString {
//    components.reduce(AttributedString(), +)
//  }
//  
//  static func buildArray(_ components: [AttributedString]) -> AttributedString {
//    components.reduce(AttributedString(), +)
//  }
//  
//  static func buildOptional(_ component: AttributedString?) -> AttributedString {
//    component ?? AttributedString()
//  }
//  
//  static func buildEither(first component: AttributedString) -> AttributedString {
//    component
//  }
//  
//  static func buildEither(second component: AttributedString) -> AttributedString {
//    component
//  }
//  
//  static func buildExpression(_ expression: AttributedString) -> AttributedString {
//    expression
//  }
//  
//  static func buildExpression(_ expression: String) -> AttributedString {
//    AttributedString(expression)
//  }
//}

// MARK: - StyledText typealias and extensions
typealias StyledText = AttributedString

extension AttributedString {
  init(@AttrStringBuilder _ content: () -> AttributedString) {
    self = content()
  }
  
  // Fluent styling methods
  func colour(_ colour: Color) -> AttributedString {
    var result = self
    result.foregroundColor = colour
    return result
  }
  
//  func font(_ font: Font) -> AttributedString {
//    var result = self
//    result.font = font
//    return result
//  }
  
  func bold() -> AttributedString {
    var result = self
    result.inlinePresentationIntent = .stronglyEmphasized
    return result
  }
  
  func italic() -> AttributedString {
    var result = self
    result.inlinePresentationIntent = .emphasized
    return result
  }
  
  func underline() -> AttributedString {
    var result = self
    result.underlineStyle = .single
    return result
  }
  
  func strikethrough() -> AttributedString {
    var result = self
    result.strikethroughStyle = .single
    return result
  }
  
  func background(_ colour: Color) -> AttributedString {
    var result = self
    result.backgroundColor = colour
    return result
  }
}

// MARK: - @AttrString function builder attribute
@resultBuilder
struct AttrString {
  static func buildBlock(_ components: AttributedString...) -> AttributedString {
    components.reduce(AttributedString(), +)
  }
  
  static func buildArray(_ components: [AttributedString]) -> AttributedString {
    components.reduce(AttributedString(), +)
  }
  
  static func buildOptional(_ component: AttributedString?) -> AttributedString {
    component ?? AttributedString()
  }
  
  static func buildEither(first component: AttributedString) -> AttributedString {
    component
  }
  
  static func buildEither(second component: AttributedString) -> AttributedString {
    component
  }
  
  static func buildExpression(_ expression: AttributedString) -> AttributedString {
    expression
  }
  
  static func buildExpression(_ expression: String) -> AttributedString {
    AttributedString(expression)
  }
}

// MARK: - Example Protocol and Usage
//protocol ValuePair {
//  var valueA: Double { get }
//  var valueB: Double { get }
//}
//
//extension ValuePair {
//  var displayStringA: String { String(format: "%.0f", valueA) }
//  var displayStringB: String { String(format: "%.0f", valueB) }
//}
//
//struct ExampleValuePair: ValuePair {
//  let valueA: Double
//  let valueB: Double
//}

// MARK: - DSL Functions
@AttrString
func valuePair(_ value: any ValuePair, separator: String = " x ") -> AttributedString {
  StyledText(value.displayStringA)
  StyledText(separator)
    .color(.secondary)
    .bold()
  StyledText(value.displayStringB)
}

@AttrString
func styledTitle(_ title: String, subtitle: String?) -> AttributedString {
  StyledText(title)
    .font(.title)
    .bold()
  
  if let subtitle {
    StyledText("\n")
    StyledText(subtitle)
      .font(.caption)
      .color(.secondary)
  }
}

@AttrString
func highlightedText(_ text: String, highlight: String) -> AttributedString {
  let parts = text.components(separatedBy: highlight)
  
  for (index, part) in parts.enumerated() {
    StyledText(part)
    
    if index < parts.count - 1 {
      StyledText(highlight)
        .backgroundColor(.yellow)
        .bold()
    }
  }
}

// MARK: - Usage Examples
//func exampleUsage() {
//  // Basic usage
//  let pair = ExampleValuePair(valueA: 1290, valueB: 340)
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

// MARK: - Advanced Example with Loops
@AttrString
func bulletList(_ items: [String]) -> AttributedString {
  for (index, item) in items.enumerated() {
    StyledText("• ")
      .color(.blue)
      .bold()
    
    StyledText(item)
    
    if index < items.count - 1 {
      StyledText("\n")
    }
  }
}

// Usage:
// let list = bulletList(["First item", "Second item", "Third item"])
