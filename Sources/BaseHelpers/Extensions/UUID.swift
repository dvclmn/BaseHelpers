//
//  UUID.swift
//  Collection
//
//  Created by Dave Coleman on 2/11/2024.
//

import Foundation

extension UUID: @retroactive RawRepresentable {
  public var rawValue: String {
    self.uuidString
  }
  
  public typealias RawValue = String
  
  public init?(rawValue: RawValue) {
    self.init(uuidString: rawValue)
  }
}
