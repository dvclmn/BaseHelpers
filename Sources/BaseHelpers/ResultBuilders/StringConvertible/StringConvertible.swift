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

extension StringConvertible where Self == Labeled {
  public func labeledStringValue(separator: String = ": ") -> String {
    self.stringValue
  }
}
