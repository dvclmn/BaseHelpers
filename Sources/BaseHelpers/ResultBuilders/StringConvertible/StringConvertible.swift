//
//  StringConvertible.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/10/2025.
//

import Foundation

public protocol StringConvertible {
  var stringValue: String { get }
}

//extension StringConvertible where Self == Labeled {
//  public func labeledStringValue(separator: String = ": ") -> String {
//    self.stringValue
//  }
//}

/// Types like `CGPoint` that have floats as it's properties
public protocol FloatGroup {
//  var labels: [Labeled] { get }
//  var separator: SeparatorType { get }
  
  func output() -> String
}

extension FloatGroup {
  public func output(
    labels: Labeled...,
    separator: String
  ) -> String {
    let separator = SeparatorType.component(separator)
    
    
  }
}
