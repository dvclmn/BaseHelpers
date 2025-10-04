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

/// The below, for some reason, can also be expressed as:
/// `Regex<Regex<Substring>.RegexOutput>.Match`
public typealias RegexMatch = Regex<Regex<Substring>.RegexOutput>.Match

/// Ranges
public typealias AttributedRange = Range<AttributedString.Index>
public typealias DoubleCaptureRange = (AttributedRange, AttributedRange)
public typealias TripleCaptureRange = (AttributedRange, AttributedRange, AttributedRange)

// MARK: - Extensions

// extension Regex<Regex.SingleCapture.RegexOutput>.Match {
extension SingleCapture.Match {

  public var displayString: String {
    DisplayString {
      Indented("Match") {
        Labeled("Range", value: self.range)
        Labeled("Matched text", value: self.0)
        Labeled("Captured group", value: self.1)
      }
      Indented("Output") {
        Labeled("Full match", value: self.output.0)
        Labeled("Capture", value: self.output.1)
      }

    }.output
  }
}

extension Regex<AnyRegexOutput>.Match {
//extension Regex<Regex<Substring>.RegexOutput>.Match {
  public var displayString: String {
    DisplayString {
      Indented("Match") {
        Labeled("Range", value: self.range)
        Labeled("Matched text", value: self.0)
      }
      Indented("Output") {
        Labeled("Full match", value: self.output)
      }
      
    }.output
  }
}
