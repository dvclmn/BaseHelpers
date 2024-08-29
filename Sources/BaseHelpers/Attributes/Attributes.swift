//
//  Attributes.swift
//  Helpers
//
//  Created by Dave Coleman on 22/8/2024.
//

import AppKit
import Foundation

public typealias Attributes = [NSAttributedString.Key: Any]

public struct AttributeSet: ExpressibleByDictionaryLiteral, Sendable {
  nonisolated(unsafe) public var attributes: Attributes
  
  public init(dictionaryLiteral elements: (Attributes.Key, Attributes.Value)...) {
    self.attributes = Dictionary(uniqueKeysWithValues: elements)
  }
  
  public init(_ attributes: Attributes) {
    self.attributes = attributes
  }
  
  public subscript(_ key: Attributes.Key) -> Any? {
    get { attributes[key] }
    set { attributes[key] = newValue }
  }
}

extension AttributeSet: Sequence {
  public func makeIterator() -> Dictionary<NSAttributedString.Key, Any>.Iterator {
    return attributes.makeIterator()
  }
}



