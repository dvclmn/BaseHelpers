//
//  SubString.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 26/9/2025.
//

import Foundation

public enum SubsequenceStrategy {
  case omitAllEmpty
  case omitLastLineIfEmpty
  case doNotOmit

  public var omitEmptySubsequences: Bool {
    switch self {
      case .omitAllEmpty:
        return true
      case .omitLastLineIfEmpty:
        return false
      case .doNotOmit:
        return false
    }
  }

}

extension String {
  
  public func lines(
    subsequenceStrategy: SubsequenceStrategy = .doNotOmit
    //    omittingEmptySubsequences: Bool = false
  ) -> [String] {
    
    let lines: [String] = self.substringLines(
      subsequenceStrategy: subsequenceStrategy
    ).map { substring in
      String(substring)
    }
    
    return lines
  }
  
  public var longestLineLength: Int {
    let longestLine = substringLines().map { $0.count }.max() ?? 1
    return longestLine
  }
  
  public func indentingEachLine(
    level: Int = 1,
    indentString: String = "\t"
  ) -> String {
    let indent = String(repeating: indentString, count: level)
    let result = self.substringLines()
      .map { indent + $0 }
      .joined(separator: "\n")
    
    return result
  }
  
  public func substringLines(
    subsequenceStrategy: SubsequenceStrategy = .doNotOmit,
  ) -> [Substring] {
    let subsequence: [Substring] = self.split(
      separator: "\n",
      maxSplits: Int.max,
      omittingEmptySubsequences: subsequenceStrategy.omitEmptySubsequences
    )

    switch subsequenceStrategy {
      case .omitAllEmpty, .doNotOmit:
        return subsequence

      case .omitLastLineIfEmpty:
        guard let lastLine = subsequence.last else { return subsequence }
        let lastLineIsEmpty: Bool = lastLine.allSatisfy { $0 == " " }
        let result = lastLineIsEmpty ? Array(subsequence.dropLast()) : subsequence
        return result

    }
  }
}
