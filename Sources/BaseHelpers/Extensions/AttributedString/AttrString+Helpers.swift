//
//  AttributedRange.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/10/2025.
//

import Foundation

extension AttributedString {

  public func findMatches(for pattern: Regex<Substring>) -> [RegexMatch] {
    let string = String(self.characters)
    let matches = string.matches(of: pattern)
    return matches
  }

  public func getRange(matching pattern: Regex<Substring>) -> AttributedRange? {
    let matches = findMatches(for: pattern)
    return matches.lazy
      .compactMap { self.range(of: $0.output) }
      .first
  }

  public func getAllRanges(matching pattern: Regex<Substring>) -> [AttributedRange] {
    let matches = findMatches(for: pattern)
    return matches.compactMap { match in
      self.range(of: match.output)
    }
  }
  
  @discardableResult
  public mutating func findRangesAndApplyAttributes(
    matching pattern: Regex<Substring>,
    attributes: AttributeContainer
  ) -> [AttributedRange] {
    let matches = findMatches(for: pattern)
    var ranges: [AttributedRange] = []
    
    for match in matches {
      if let range = self.range(of: match.output) {
        self[range].setAttributes(attributes)
        ranges.append(range)
      }
    }
    return ranges
  }

  #warning("Find way to write similar code for Single, Double, Triple captures, without redundancy etc")
//  public func getRange(for pattern: TripleCapture) -> TripleCaptureRange? {
//
//    let string = String(self.characters)
//
//    let matches = string.matches(of: pattern)
//
//    for match in matches {
//      guard let range01 = self.range(of: match.output.1),
//        let range02 = self.range(of: match.output.2),
//        let range03 = self.range(of: match.output.3)
//      else {
//
//        break
//      }
//
//      return (range01, range02, range03)
//    }
//    return nil
//  }

}
