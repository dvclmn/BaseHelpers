//
//  String.swift
//  TextCore
//
//  Created by Dave Coleman on 9/10/2024.
//

import Foundation


public extension String {
  
  var lines: [Substring] {
    let result = self.split(
      separator: "\n",
      maxSplits: Int.max,
      omittingEmptySubsequences: false
    )
    return result
  }
  
  func lines(omittingEmptySubsequences: Bool) -> [Substring] {
    let result = self.split(
      separator: "\n",
      maxSplits: Int.max,
      omittingEmptySubsequences: omittingEmptySubsequences
    )
    return result
  }
  
  var longestLineLength: Int {
//    print("Let's get longest line length.")
//    print("Line count: \(lines.count)")
    let longestLine = lines.map { $0.count }.max() ?? 1
    
    
//    print("Longest line length: \(longestLine)")
    
    return longestLine
  }
  
  func indentingEachLine(_ level: Int = 1, indentChar: String = "\t") -> String {
    let indent = String(repeating: indentChar, count: level)
    let result = self.lines
      .map { indent + $0 }
      .joined(separator: "\n")
    
    return result
  }
  

  func components(separatedBy separator: Character) -> [String] {
    return self.split(separator: separator).map(String.init)
  }
  
  var wordCount: Int {
    let words = self.split { !$0.isLetter }
    return words.count
  }
  
  func nsRange(from range: Range<String.Index>) -> NSRange {
    return NSRange(range, in: self)
  }
  
  func range(from nsRange: NSRange) -> Range<String.Index>? {
    return Range(nsRange, in: self)
  }
  
  func substring(with nsRange: NSRange) -> Substring? {
    guard let range = self.range(from: nsRange) else { return nil }
    return self[range]
  }
  
  /// A `prefix(_ maxLength: Int)` alternative, returning a `String` rather than `Substring`
  func preview(
    _ maxLength: Int = 20,
    hasDividers: Bool = true,
    showsEnd: Bool = true
  ) -> String {
    let totalLength = self.count
    
    /// Handle the case where the provided string is actually *shorter*
    /// than the `maxLength`
    if totalLength <= maxLength {
      
      if self.isEmpty {
        
        return "(Empty line)"
      } else {
        return hasDividers ? "\n---\n\(self)\n---\n\n" : self
      }
    }
    
    let prefixLength = min(maxLength / 2, totalLength / 2)
    let suffixLength = min(maxLength - prefixLength - 3, totalLength - prefixLength - 3)
    
    let prefix = self.prefix(prefixLength)
    let suffix = showsEnd ? self.suffix(suffixLength) : ""
    
    let result = "\(prefix)...\(suffix)"
    
    if hasDividers {
      return "\n---\n\(result)\n---\n\n"
    } else {
      return result
    }
  }
}


