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
public typealias SingleCapture = Regex<(Substring, Substring)>
public typealias DoubleCapture = Regex<(Substring, Substring, Substring)>
public typealias TripleCapture = Regex<(Substring, Substring, Substring, Substring)>
//extension Regex {
//}

/// Ranges
public typealias AttributedRange = Range<AttributedString.Index>


public typealias DoubleCaptureRange = (
  AttributedRange,
  AttributedRange,
)
//extension DoubleCapture {
//}

public typealias TripleCaptureRange = (
  AttributedRange,
  AttributedRange,
  AttributedRange,
)

// MARK: - Extensions

// extension Regex<Regex.SingleCapture.RegexOutput>.Match {
extension SingleCapture.Match {

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

  //  public func boxedDescription(header: String) -> String {
  //
  //    fatalError("Need to implement this")
  //    return SwiftBox.draw(header: header, content: self.prettyDescription)
  //  }
  //
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
