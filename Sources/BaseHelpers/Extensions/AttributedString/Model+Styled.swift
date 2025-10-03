//
//  Model+Styled.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/10/2025.
//

import Foundation

/// This is a non-Named-Capture type, at least for now.
/// Aka just `Regex<Substring>`, which will
/// return the whole capture, nothing named
public struct RunStyle {
  let pattern: Regex<Substring>
  let attributes: AttributeContainer
}

public struct Styled {
  let styles: [RunStyle]
  let sourceText: String
  
}

extension Styled {
  public func output() -> AttributedString {
    for style in styles {
      
    }
  }
  
  private func apply(
    runStyle: RunStyle,
    in sourceText: String,
    to attributedString: inout AttributedString
  ) {
//    let pattern: Regex<AnyRegexOutput> = runStyle.pattern
    
//    let string = String(attributedString.characters)
//    let matches = string.matches(of: pattern)
    
    attributedString.findRangesAndApplyAttributes(
      matching: runStyle.pattern,
      attributes: runStyle.attributes
    )
//    var ranges: [AttributedRange] = []
    
//    for match in matches {
//      attributedString.getRange(matching: <#T##Regex<Substring>#>)
//      guard let range = attributedString.range(of: match.output) else { continue }
//      attrString[fullRange].setAttributes(AttributeContainer.fromTheme(theme, for: type))
//      ranges.append(fullRange)
//    }
  }
}

//extension Metrics {
//  
//  static func metricContent(_ attrString: AttributedString) -> AttributedString {
//    var output = attrString
//    
//    let pattern: MetricsRegex = /(?<styleTarget>x|y|X|Y|:\s|,\s|W|H|Column|COL|Row|ROW|ROWS|COLS)/
//    
//    /// Get matches and their named captures
//    let string = String(output.characters)
//    let matches = string.matches(of: pattern)
//    
//    for match in matches {
//      guard let range = output.range(of: match.output.styleTarget) else {
//        break
//      }
//      output[range].setAttributes(style)
//    }
//    
//    return output
//  }
//  
//  private static var style: AttributeContainer {
//    var container = AttributeContainer()
//    
//    container.backgroundColor = .clear
//    container.foregroundColor = .secondary.opacity(0.6)
//    container.font = .caption.weight(.medium)
//    
//    return container
//  }
//}
