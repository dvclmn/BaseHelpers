//
//  Regex.swift
//  Collection
//
//  Created by Dave Coleman on 14/2/2025.
//

import Foundation

// MARK: - Typealiases

/// Reminder: The first `Substring` is always the whole match,
/// then subsequent are those specifically defined/named.
///
/// As per the docs:
/// - A `Regex` with captures created from a regex literal or the
///   ``init(_:as:)`` initializer has a tuple of substrings as its output
///   type. The first component of the tuple is the full portion of the string
///   that was matched, with the remaining components holding the captures.
public typealias MarkdownRegex = Regex<
  (
    Substring,
    leading: Substring,
    content: Substring,
    trailing: Substring
  )
>
public typealias MarkdownRegexOutput = MarkdownRegex.RegexOutput
public typealias MarkdownRegexMatch = Regex<MarkdownRegexOutput>.Match

/// Note: Despite what the name `TwoPartRegex` implies,  the three
/// `Substring`s here are intentional. One for the *whole* match
/// combined, and the other two for the defined matches.
public typealias TwoPartRegex = Regex<
  (
    Substring,
    Substring,
    Substring
  )
>
public typealias ThreePartRegex = Regex<
  (
    Substring,
    Substring,
    Substring,
    Substring
  )
>

/// Ranges
public typealias AttributedRange = Range<AttributedString.Index>

public typealias TwoPartRange = (
  AttributedRange,
  AttributedRange
)

public typealias ThreePartRange = (
  AttributedRange,
  AttributedRange,
  AttributedRange
)

// MARK: - Extensions
extension MarkdownRegexMatch {

  public var prettyDescription: String {

    var result = "Match:\n"
    result += "  Range: Lower bound: \(self.range.lowerBound), Upper bound: \(self.range.upperBound)\n"
    result += "  Matched text: \"\(self.0)\"\n"
    result += "  Output:\n"
    result += "    Full match: \"\(self.0)\"\n"
    result += "    Leading: \"\(self.leading)\"\n"
    result += "    Content: \"\(self.content)\"\n"
    result += "    Trailing: \"\(self.trailing)\"\n"
    return result

  }

  public var briefDescription: String {

    let result =
      "Matches (leading, content, trailing):  ░░░░░\"\(self.output.leading)\"░░░░░\"\(self.output.content)\"░░░░░\"\(self.output.trailing)\"░░░░░\n"
    return result

  }

  public func boxedDescription(header: String) -> String {
    fatalError("Need to implement this")

    //    return SwiftBox.drawBox(
    //      header: header,
    //      content: self.prettyDescription
    //    )
  }
}

extension Regex<Regex<(Substring, Substring)>.RegexOutput>.Match {

  public var prettyDescription: String {
    var result = "Match:\n"
    result += "  Range: \(self.range)\n"
    result += "  Matched text: \"\(self.0)\"\n"

    if !self.1.isEmpty {
      result += "  Captured group: \"\(self.1)\"\n"
    }

    result += "  Output:\n"
    result += "    Full match: \"\(self.output.0)\"\n"
    result += "    Capture: \"\(self.output.1)\"\n"
    return result
  }

  public func boxedDescription(header: String) -> String {

    fatalError("Need to implement this")
    //    return SwiftBox.draw(header: header, content: self.prettyDescription)
  }

}

extension Regex<Regex<Substring>.RegexOutput>.Match {
  public var prettyDescription: String {
    var result = "Match:\n"
    result += "  Range: \(self.range)\n"
    result += "  Matched text: \"\(self)\"\n"

    result += "  Output:\n"
    result += "  Full match: \"\(self.output)\"\n"
    return result
  }
}

extension NSRegularExpression.Options {
  public var displayString: String {
    var options: [String] = []

    if contains(.caseInsensitive) { options.append("caseInsensitive") }
    if contains(.allowCommentsAndWhitespace) { options.append("allowCommentsAndWhitespace") }
    if contains(.ignoreMetacharacters) { options.append("ignoreMetacharacters") }
    if contains(.dotMatchesLineSeparators) { options.append("dotMatchesLineSeparators") }
    if contains(.anchorsMatchLines) { options.append("anchorsMatchLines") }
    if contains(.useUnixLineSeparators) { options.append("useUnixLineSeparators") }
    if contains(.useUnicodeWordBoundaries) { options.append("useUnicodeWordBoundaries") }

    return options.isEmpty ? "[]" : "[\(options.joined(separator: ", "))]"
  }
}

extension NSRegularExpression.MatchingOptions {
  public var displayString: String {
    var options: [String] = []

    if contains(.reportProgress) { options.append("reportProgress") }
    if contains(.reportCompletion) { options.append("reportCompletion") }
    if contains(.anchored) { options.append("anchored") }
    if contains(.withTransparentBounds) { options.append("withTransparentBounds") }
    if contains(.withoutAnchoringBounds) { options.append("withoutAnchoringBounds") }

    return options.isEmpty ? "[]" : "[\(options.joined(separator: ", "))]"
  }
}

extension NSRegularExpression {
  public func matches(in string: String, options: NSRegularExpression.MatchingOptions = []) -> [NSTextCheckingResult] {
    return matches(in: string, options: options, range: NSRange(location: 0, length: string.utf16.count))
  }

  public func firstMatch(in string: String, options: NSRegularExpression.MatchingOptions = []) -> NSTextCheckingResult?
  {
    return firstMatch(in: string, options: options, range: NSRange(location: 0, length: string.utf16.count))
  }
}
