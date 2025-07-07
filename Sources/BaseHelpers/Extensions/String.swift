//
//  String.swift
//  TextCore
//
//  Created by Dave Coleman on 9/10/2024.
//

import Foundation

extension String {
  
  public var addNewLine: String {
    guard self.last != "\n" else {
      return self
    }
    return self + "\n"
  }

  public func lines(
    omittingEmptySubsequences: Bool = false
  ) -> [String] {

    let lines: [String] = self.substringLines(omittingEmptySubsequences: omittingEmptySubsequences).map { substring in
      String(substring)
    }

    return lines
  }

  public func substringLines(omittingEmptySubsequences: Bool = false) -> [Substring] {
    let result = self.split(
      separator: "\n",
      maxSplits: Int.max,
      omittingEmptySubsequences: omittingEmptySubsequences
    )
    return result
  }

  public var url: URL? {
    return URL(string: self)
  }

  public var longestLineLength: Int {
    let longestLine = substringLines().map { $0.count }.max() ?? 1
    return longestLine
  }

  public var gridDimensions: GridDimensions {
    let columns: Int = longestLineLength
    let rows: Int = substringLines().count
    return GridDimensions(columns: columns, rows: rows)
  }

  public func indentingEachLine(_ level: Int = 1, indentChar: String = "\t") -> String {
    let indent = String(repeating: indentChar, count: level)
    let result = self.substringLines()
      .map { indent + $0 }
      .joined(separator: "\n")

    return result
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

  // MARK: - Usage Examples
  /*
   let uuid = "550e8400-e29b-41d4-a716-446655440000"
   print(uuid.truncateMiddle(maxLength: 8))  // "550e...0000" (4 + 4 chars)
  
   let shortText = "Hello"
   print(shortText.truncateMiddle(maxLength: 10))  // "Hello"
  
   let longText = "This is a very long string that needs truncation"
   print(longText.truncateMiddle(maxLength: 12))  // "This i...cation" (6 + 6 chars)
   print(longText.truncateMiddle(maxLength: 10))  // "This ...ation" (5 + 5 chars)
   print(longText.truncateMiddle(maxLength: 15, showEnd: false))  // "This is a very ..."
  
   let empty = ""
   print(empty.truncateMiddle())  // "(Empty)"
   */

  //  /// A `prefix(_ maxLength: Int)` alternative, returning a `String` rather than `Substring`
  //  func preview(
  //    _ maxLength: Int = 20,
  //    hasDividers: Bool = true,
  //    showsEnd: Bool = true
  //  ) -> String {
  //    let totalLength = self.count
  //
  //    /// Handle the case where the provided string is actually *shorter*
  //    /// than the `maxLength`
  //    if totalLength <= maxLength {
  //
  //      if self.isEmpty {
  //
  //        return "(Empty line)"
  //      } else {
  //        return hasDividers ? "\n---\n\(self)\n---\n\n" : self
  //      }
  //    }
  //
  //    let prefixLength = min(maxLength / 2, totalLength / 2)
  //    let suffixLength = min(maxLength - prefixLength - 3, totalLength - prefixLength - 3)
  //
  //    let prefix = self.prefix(prefixLength)
  //    let suffix = showsEnd ? self.suffix(suffixLength) : ""
  //
  //    let result = "\(prefix)...\(suffix)"
  //
  //    if hasDividers {
  //      return "\n---\n\(result)\n---\n\n"
  //    } else {
  //      return result
  //    }
  //  }
}
