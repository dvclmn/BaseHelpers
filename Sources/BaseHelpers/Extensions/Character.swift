//
//  Character.swift
//  Collection
//
//  Created by Dave Coleman on 15/12/2024.
//

import Foundation

extension Character {
  public var toString: String {
    String(self)
  }

  public var descriptiveName: String? {
    switch self {
      case " ": "Space"
      case "\n": "New Line"
      case "\t": "Tab"
      case "(": "Left Parenthesis"
      case ")": "Right Parenthesis"
      case "[": "Left Square Bracket"
      case "]": "Right Square Bracket"
      case "{": "Left Curly Brace"
      case "}": "Right Curly Brace"
      case "<": "Less Than Sign"
      case ">": "Greater Than Sign"
      case "&": "Ampersand"
      case "@": "At Sign"
      case "#": "Number Sign"
      case "%": "Percent Sign"
      case "$": "Dollar Sign"
      default: nil
    }
  }
}

// https://gist.github.com/john-mueller/cb5fe3d39afe47ad7c94a84a6670e010
extension Character: Codable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(String(self))
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let string = try container.decode(String.self)

    guard let character = string.first else {
      throw DecodingError.dataCorruptedError(
        in: container,
        debugDescription: "Empty String cannot be converted to Character."
      )
    }

    guard string.count == 1 else {
      throw DecodingError.dataCorruptedError(
        in: container,
        debugDescription: "Multi-character String cannot be converted to Character."
      )
    }

    self = character
  }

}
