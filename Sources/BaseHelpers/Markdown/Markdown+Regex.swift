//
//  Markdown+Regex.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/10/2025.
//

import Foundation

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
