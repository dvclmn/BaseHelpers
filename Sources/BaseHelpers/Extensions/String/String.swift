//
//  String.swift
//  TextCore
//
//  Created by Dave Coleman on 9/10/2024.
//

import SwiftUI

extension String {

  public enum QuotesType: String {
    case single = "'"
    case double = "\""
  }

  public var toURL: URL? {
    return URL(string: self)
  }

  public var withQuotes: String {
    self.withQuotes(.double)
  }

  public func findMatches(for pattern: Regex<Substring>) -> [RegexMatch] {
    //    let string = String(self.characters)
    let matches = self.matches(of: pattern)
    return matches
  }

  public func getRange(
    for attributedString: AttributedString,
    matching pattern: Regex<Substring>
  ) -> AttributedRange? {
    let matches = findMatches(for: pattern)
    return attributedString.getRange(for: matches)
  }

  public func getAllRanges(
    for attributedString: AttributedString,
    matching pattern: Regex<Substring>
  ) -> [AttributedRange] {
    let matches = findMatches(for: pattern)
    return attributedString.getAllRanges(for: matches)
    //    let matches = findMatches(for: pattern)
    //    return matches.compactMap { match in
    //      self.range(of: match.output)
    //    }
  }

  @discardableResult
  public mutating func findRangesAndApplyAttributes(
    to attributedString: inout AttributedString,
    matching pattern: Regex<Substring>,
    attributes: AttributeContainer
  ) -> [AttributedRange] {
    let matches = findMatches(for: pattern)
    return attributedString.findRangesAndApplyAttributes(for: matches, attributes: attributes)
//    var ranges: [AttributedRange] = []
//
//    for match in matches {
//      if let range = attributedString.range(of: match.output) {
//        attributedString[range].setAttributes(attributes)
//        ranges.append(range)
//      }
//    }
//    return ranges
  }

  public func withQuotes(_ type: QuotesType = .double) -> String {
    return "\(type.rawValue)\(self)\(type.rawValue)"
  }

  public var toAttributedString: AttributedString {
    return AttributedString(self)
  }

  public var toMarkdownCompatible: LocalizedStringKey {
    LocalizedStringKey(self)
  }

  //  public static func createBlankString(
  //    width: Int,
  //    height: Int,
  //    character: Character = " "
  //  ) -> String {
  //    precondition(width > 0 && height > 0, "Cannot create a string with zero width or height.")
  //
  //    let rowString = String(repeating: character, count: width)
  //    let rows = Array(repeating: rowString, count: height)
  //    return rows.joined(separator: "\n")
  //  }

  public var firstLine: String {
    let firstSubstring = self.split(separator: "\n").first ?? ""
    return String(firstSubstring)
  }

  /// Adds a new line to the end of the current String, unless already present
  public var addingNewLine: String {
    guard self.last != "\n" else {
      return self
    }
    return self + "\n"
  }

  public func components(separatedBy separator: Character) -> [String] {
    return self.split(separator: separator).map(String.init)
  }

  public var wordCount: Int {
    let words = self.split { !$0.isLetter }
    return words.count
  }

  public func nsRange(from range: Range<String.Index>) -> NSRange {
    return NSRange(range, in: self)
  }

  public func range(from nsRange: NSRange) -> Range<String.Index>? {
    return Range(nsRange, in: self)
  }

  public func substring(with nsRange: NSRange) -> Substring? {
    guard let range = self.range(from: nsRange) else { return nil }
    return self[range]
  }

  /// ```
  /// let test1 =   "a[b]c".slice(from: "[", to: "]") // "b"
  /// let test2 =     "abc".slice(from: "[", to: "]") // nil
  /// let test3 =   "a]b[c".slice(from: "[", to: "]") // nil
  /// let test4 = "[a[b]c]".slice(from: "[", to: "]") // "a[b"
  /// ```
  public func slice(from: String, to: String) -> String? {
    guard let rangeFrom = range(of: from)?.upperBound else { return nil }
    guard let rangeTo = self[rangeFrom...].range(of: to)?.lowerBound else { return nil }
    return String(self[rangeFrom..<rangeTo])
  }

  /// Truncates a string to show a maximum number of content characters with ellipsis in the middle.
  /// The ellipsis ("...") does not count toward the maxLength.
  ///
  /// Examples:
  /// - "Hello World".truncateMiddle(maxLength: 8) → "Hell...orld" (4 + 4 chars)
  /// - "Short".truncateMiddle(maxLength: 10) → "Short" (unchanged)
  /// - "UUID-1234-5678-9ABC-DEF0".truncateMiddle(maxLength: 8) → "UUID...DEF0" (4 + 4 chars)
  /// - "".truncateMiddle() → "(Empty)"
  ///
  /// - Parameters:
  ///   - maxLength: Maximum number of content characters to show (ellipsis not counted, minimum 2)
  ///   - showEnd: Whether to show characters from the end. If false, only shows beginning + ellipsis
  ///   - wrapWithDividers: Whether to wrap the result in decorative dividers for display
  ///   - emptyPlaceholder: Text to show when the string is empty
  /// - Returns: Truncated string with ellipsis, or original string if shorter than maxLength
  public func truncateMiddle(
    maxLength: Int = 20,
    showEnd: Bool = true,
    wrapWithDividers: Bool = false,
    emptyPlaceholder: String = "(Empty)"
  ) -> String {

    // Handle empty string
    if self.isEmpty {
      let result = emptyPlaceholder
      return wrapWithDividers ? wrapInDividers(result) : result
    }

    // Ensure minimum length for meaningful truncation
    let minLength = 2  // Minimum to show at least 1 char on each side (or 2 chars + "..." if showEnd is false)
    let effectiveMaxLength = max(minLength, maxLength)

    // If string is short enough, return as-is
    if self.count <= effectiveMaxLength {
      return wrapWithDividers ? wrapInDividers(self) : self
    }

    let ellipsis = "..."

    let result: String

    if showEnd {
      // Show beginning and end: "begin...end"
      // Split the maxLength evenly between prefix and suffix
      let prefixLength = effectiveMaxLength / 2
      let suffixLength = effectiveMaxLength - prefixLength  // This handles odd numbers by giving extra to suffix

      let prefix = String(self.prefix(prefixLength))
      let suffix = String(self.suffix(suffixLength))

      result = "\(prefix)\(ellipsis)\(suffix)"
    } else {
      // Show only beginning: "begin..."
      let prefix = String(self.prefix(effectiveMaxLength))

      result = "\(prefix)\(ellipsis)"
    }

    return wrapWithDividers ? wrapInDividers(result) : result
  }

  /// Wraps text in decorative dividers for display purposes
  private func wrapInDividers(_ text: String) -> String {
    return "\n---\n\(text)\n---\n"
  }

  public var camelToSnake: String {
    var result = ""
    for (index, ch) in self.enumerated() {
      if ch.isUppercase {
        if index > 0 { result.append("_") }
        result.append(ch.lowercased())
      } else {
        result.append(ch)
      }
    }
    return result
  }

  //  public func newLinesIndented() -> String {
  //    let lines: [String.SubSequence] = self.split(separator: "\n", omittingEmptySubsequences: true)
  //
  //    let output: String = "\n  | " + lines.joined(separator: "\n  | ")
  //    return output
  //  }
}

extension Array where Element == String {
  public func joined(_ separator: String = "") -> String {
    self.joined(separator: separator)
  }
}

extension String {
  //extension Optional where Wrapped == String {
  public var toDescribing: String {
    return String(describing: self)
  }
}
