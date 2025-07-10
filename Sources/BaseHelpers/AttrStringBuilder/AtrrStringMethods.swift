//
//  AtrrStringMethods.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/7/2025.
//

import Foundation

// MARK: - DSL Functions
@AttrString
public func valuePair<T: DisplayPair>(
  _ value: T,
  places: DecimalPlaces = .fractionLength(2),
  separator: String = "x",
  hasSpace: Bool = true
) -> AttributedString {
  StyledText(value.valueA.displayString(places))
  StyledText(hasSpace ? " \(separator) " : separator)
    .colour(.secondary)
    .bold()
  StyledText(value.valueB.displayString(places))
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
