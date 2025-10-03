//
//  Regex.swift
//  Collection
//
//  Created by Dave Coleman on 14/2/2025.
//

import Foundation

// MARK: - Typealiases

/// A `Regex` with captures created from a regex literal or the
///   ``init(_:as:)`` initializer.
///
/// The output type is a tuple of substrings.
///
/// Important: The *first* component of the tuple is the full portion of the string
/// that was matched, with the remaining components holding the captures.
///
/// That's why each of these has one more than it's name implies,
/// as the first handles the whole match.
extension Regex {
  public typealias SingleCapture = Regex<(Substring, Substring)>
  public typealias DoubleCapture = Regex<(Substring, Substring, Substring)>
  public typealias TripleCapture = Regex<(Substring, Substring, Substring, Substring)>
}

/// Ranges
public typealias AttributedRange = Range<AttributedString.Index>

// MARK: - Extensions

extension Regex where Self.RegexOutput == (Substring, Substring) {
  
}

extension Regex<Regex.SingleCapture.RegexOutput>.Match {

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
