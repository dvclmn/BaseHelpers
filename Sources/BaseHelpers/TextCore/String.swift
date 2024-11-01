//
//  String.swift
//  TextCore
//
//  Created by Dave Coleman on 9/10/2024.
//

public extension String {
  
  func indentingEachLine(_ level: Int = 1, indentChar: String = "\t") -> String {
    let indent = String(repeating: indentChar, count: level)
    return self.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)
      .map { indent + $0 }
      .joined(separator: "\n")
  }
  

  func components(separatedBy separator: Character) -> [String] {
    return self.split(separator: separator).map(String.init)
  }
}
