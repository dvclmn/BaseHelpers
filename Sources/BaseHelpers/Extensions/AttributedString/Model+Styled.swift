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
///
/// Note: previously had the below defined to catch a
/// whole lot of possible key words for
/// ```
/// /(?<styleTarget>x|y|X|Y|:\s|,\s|W|H|Column|COL|Row|ROW|ROWS|COLS)/
/// ```
public struct RunStyle {
  let pattern: Regex<Substring>

  /// For more styles and info, see
  /// `BaseHelpers/Extensions/AttributedString/AttributeContainer`
  let attributes: AttributeContainer
}

public struct Styled {
  let styles: [RunStyle]
  let sourceText: String
}

extension Styled {
  public func output() -> AttributedString {
    var result = AttributedString(sourceText)
    for style in styles {
      apply(runStyle: style, to: &result)
    }
    return result
  }

  private func apply(
    runStyle: RunStyle,
    to attributedString: inout AttributedString
  ) {
    sourceText.findRangesAndApplyAttributes(
      to: &attributedString,
      matching: runStyle.pattern,
      attributes: runStyle.attributes
    )
  }
}
