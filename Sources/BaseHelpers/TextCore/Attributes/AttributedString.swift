//
//  AttributedString.swift
//  TextCore
//
//  Created by Dave Coleman on 31/8/2024.
//

import SwiftUI

public extension AttributedString {
  
  ///
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
  ///
  
  //  func quickHighlight(_ string: inout AttributedString) {
  //    let highlightContainer: AttributeContainer = .highlighter
  //
  //    string.setAttributes(highlightContainer)
  //
  //  }
  
  
  mutating func quickHighlight() {
    
    print(self.string)
    
    let highlightContainer: AttributeContainer = .highlighter
    self.setAttributes(highlightContainer)
  }
  
  
  func getAllRanges(matching pattern: Regex<Substring>) -> [AttributedRange] {
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
  
  func getRange(for pattern: ThreePartRegex) -> ThreePartRange? {
    
    //    var range: Range<AttributedString.Index>
    
    //    var output = ThreePartRegex.AttributedRange()
    
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
  
  func getRange(matching pattern: Regex<Substring>) -> AttributedRange? {
    
    let string = String(self.characters)
    
    let matches = string.matches(of: pattern)
    
    for match in matches {
      
      guard let range = self.range(of: match.output) else { break }
      
      return range
      
    }
    return nil
  }
  
  func debugRanges(matching pattern: Regex<Substring>) {
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
  
  //  func getAllRangesIncremental(matching pattern: Regex<Substring>) -> [Range<AttributedString.Index>] {
  //    let string = String(self.characters)
  //    var ranges: [Range<AttributedString.Index>] = []
  //    var searchRange = string.startIndex..<string.endIndex
  //
  //    while let match = string.range(of: pattern, range: searchRange) {
  //      if let attrRange = self.range(of: string[match]) {
  //        ranges.append(attrRange)
  //      }
  //      searchRange = match.upperBound..<string.endIndex
  //    }
  //
  //    return ranges
  //  }
  
  //  func setStyle(in range: AttributedRange, attrString: inout Self) {
  //
  //  }
}


//
//extension AttributedString {
//  func getAllRangesParallel(matching pattern: Regex<Substring>) -> [Range<AttributedString.Index>] {
//    let string = String(self.characters)
//    let chunkSize = max(1000, string.count / ProcessInfo.processInfo.activeProcessorCount)
//
//    let ranges = string.chunks(ofCount: chunkSize).parallelMap { chunk in
//      string.ranges(of: pattern, range: chunk.startIndex..<chunk.endIndex)
//    }.flatMap { $0 }
//
//    return ranges.compactMap { self.range(of: string[$0]) }
//  }
//}
//
//extension Sequence {
//  func parallelMap<T>(_ transform: @escaping (Element) -> T) -> [T] {
//    let result = Array<T?>(repeating: nil, count: self.underestimatedCount)
//    DispatchQueue.concurrentPerform(iterations: result.count) { idx in
//      result[idx] = transform(self[self.index(self.startIndex, offsetBy: idx)])
//    }
//    return result.compactMap { $0 }
//  }
//  }

//
//extension AttributedString {
//
//  func getAllRanges(matching pattern: Regex<Substring>) -> [AttributedRange] {
//
//    let string = String(self.characters)
//    let matches = string.matches(of: pattern)
//
//    var ranges: [AttributedRange] = []
//
//    var searchStartIndex = self.startIndex
//
//    for match in matches {
//      let matchString = String(match.output)
//
//      while true {
//        guard let matchStartIndex = self.index(of: matchString, from: searchStartIndex) else {
//          break // No more matches found
//        }
//
//        let matchEndIndex = self.index(matchStartIndex, offsetByCharacters: matchString.count)
//
//        ranges.append(matchStartIndex..<matchEndIndex)
//
//        // Move the search start index just past this match
//        searchStartIndex = self.index(afterCharacter: matchStartIndex)
//
//        // If we've reached the end of the string, break
//        if searchStartIndex >= self.endIndex {
//          break
//        }
//      }
//    }
//
//    return ranges
//  }
//
//  private func index(of substring: String, from startIndex: AttributedString.Index) -> AttributedString.Index? {
//    var currentIndex = startIndex
//    while currentIndex < self.endIndex {
//      let endIndex = self.index(currentIndex, offsetByCharacters: substring.count)
//      let subAttString = self[currentIndex..<endIndex]
//      if String(subAttString.characters) == substring {
//        return currentIndex
//      }
//      currentIndex = self.index(afterCharacter: currentIndex)
//    }
//    return nil
//  }
//}


public extension AttributedString {
  //  var addLineBreak: AttributedString {
  //
  //    var current: AttributedString = self
  //
  //    current.characters.append("\n")
  //
  //    return current
  //  }
  
  var string: String {
    String(self.characters)
  }
  
  mutating func appendString(_ newString: String, addsLineBreak: Bool) {
    
    self.characters.append(contentsOf: newString)
    if addsLineBreak {
      self.characters.append("\n")
    }
  }
  
  mutating func appendString(_ newCharacter: Character, addsLineBreak: Bool) {
    
    self.characters.append(newCharacter)
    if addsLineBreak {
      self.characters.append("\n")
    }
    
  }
  
  mutating func addLineBreak() {
    
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
    for _ in 0..<count {
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
