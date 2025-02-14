//
//  AttributedString.swift
//  TextCore
//
//  Created by Dave Coleman on 31/8/2024.
//

import SwiftUI

extension AttributedString {
  ///
  /// ```
  /// var output = attrString
  ///
  /// let numberByNumberPattern: ThreePartRegex = /([\d\.]+)(x)([\d\.]+)/
  ///
  /// if let ranges = getRange(for: numberByNumberPattern, in: output) {
  ///   output[ranges.0].setAttributes(style(for: part, subPart: .number))
  ///   output[ranges.1].setAttributes(style(for: part, subPart: .operator))
  ///   output[ranges.2].setAttributes(style(for: part, subPart: .number))
  /// }
  ///
  /// return output
  /// ```

  public mutating func quickHighlight() {

    print(self.string)

    let highlightContainer: AttributeContainer = .highlighter
    self.setAttributes(highlightContainer)
  }

  public func getAllRanges(matching pattern: Regex<Substring>) -> [AttributedRange] {
    let string = String(self.characters)
    let matches = string.matches(of: pattern)

    var ranges: [Range<AttributedString.Index>] = []

    for match in matches {
      if let range = self.range(of: match.output) {
        ranges.append(range)
      }
    }
    return ranges
  }

  public func getRange(for pattern: ThreePartRegex) -> ThreePartRange? {

    let string = String(self.characters)

    let matches = string.matches(of: pattern)

    for match in matches {
      guard let range01 = self.range(of: match.output.1),
        let range02 = self.range(of: match.output.2),
        let range03 = self.range(of: match.output.3)
      else {

        break
      }

      return (range01, range02, range03)
    }
    return nil
  }

  public func getRange(matching pattern: Regex<Substring>) -> AttributedRange? {
    let string = String(self.characters)
    let matches = string.matches(of: pattern)
    for match in matches {
      guard let range = self.range(of: match.output) else { break }
      return range

    }
    return nil
  }

  public func debugRanges(matching pattern: Regex<Substring>) {
    let string = String(self.characters)
    let matches = string.matches(of: pattern)

    print("Total matches found: \(matches.count)")

    for (index, match) in matches.enumerated() {
      let matchString = String(match.output)
      print("Match \(index + 1): '\(matchString)'")

      if let range = self.range(of: matchString) {
        print("  Found at range: \(range)")
        print("  Content at range: '\(self[range])'")
      } else {
        print("  Range not found in AttributedString")
      }

      print("---")
    }
  }

  public var lines: [String] {
    let string = String(self.characters)
    return string.split(separator: "\n", omittingEmptySubsequences: false)
      .map { String($0) }
  }
  

  //  var addLineBreak: AttributedString {
  //
  //    var current: AttributedString = self
  //
  //    current.characters.append("\n")
  //
  //    return current
  //  }

  public var string: String {
    String(self.characters)
  }

  public mutating func appendString(_ newString: String, addsLineBreak: Bool) {

    self.characters.append(contentsOf: newString)
    if addsLineBreak {
      self.characters.append("\n")
    }
  }

  public mutating func appendString(_ newCharacter: Character, addsLineBreak: Bool) {

    self.characters.append(newCharacter)
    if addsLineBreak {
      self.characters.append("\n")
    }

  }

  public mutating func addLineBreak() {

    self.appendString("\n", addsLineBreak: false)
    //    self.characters.append("\n")
  }

}


public struct MultiLineAttributedString {
  private var lines: [AttributedString]

  public init(_ lines: [AttributedString] = []) {
    self.lines = lines
  }

  public mutating func appendLine(_ line: AttributedString) {
    lines.append(line)
  }

  public mutating func appendLine(_ line: String) {
    lines.append(AttributedString(line))
  }

  public mutating func append(_ other: MultiLineAttributedString) {
    if lines.isEmpty {
      lines = other.lines
    } else {
      for (index, line) in other.lines.enumerated() {
        if index < lines.count {
          lines[index] += line
        } else {
          lines.append(line)
        }
      }
    }
  }

  public func repeated(_ count: Int) -> MultiLineAttributedString {
    var result = MultiLineAttributedString()
    for _ in 0 ..< count {
      result.append(self)
    }
    return result
  }

  public var attributedString: AttributedString {
    lines.reduce(into: AttributedString()) { result, line in
      if !result.characters.isEmpty {
        result += AttributedString("\n")
      }
      result += line
    }
  }

  // New method to append to an existing AttributedString
  public func appendTo(_ attrString: inout AttributedString, addsLineBreak: Bool = true) {
    for (index, line) in lines.enumerated() {
      if index > 0 || !attrString.characters.isEmpty {
        attrString += AttributedString("\n")
      }
      attrString += line
    }
    if addsLineBreak && !lines.isEmpty {
      attrString += AttributedString("\n")
    }
  }

  public var description: String {
    lines.map { $0.description }.joined(separator: "\n")
  }


}

//public extension MultiLineAttributedString {
//  static func +(lhs: MultiLineAttributedString, rhs: MultiLineAttributedString) -> MultiLineAttributedString {
//    var result = lhs
//    result.append(rhs)
//    return result
//  }
//}
