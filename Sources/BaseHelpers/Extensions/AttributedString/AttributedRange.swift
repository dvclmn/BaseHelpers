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
    for match in matches {
      guard let range = self.range(of: match.output) else { break }
      return range
    }
    return nil
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
  
  public func getRange(for pattern: TripleCapture) -> TripleCaptureRange? {
    
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
  
  
}
