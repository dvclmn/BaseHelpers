//
//  Character.swift
//  Collection
//
//  Created by Dave Coleman on 15/12/2024.
//

import Foundation

public extension Character {
  var toString: String {
    String(self)
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
