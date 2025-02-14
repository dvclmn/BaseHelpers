//
//  MultilineString.swift
//  Collection
//
//  Created by Dave Coleman on 14/2/2025.
//

import Foundation

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
