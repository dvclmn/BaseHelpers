//
//  Model+Indented.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/10/2025.
//

import Foundation

public struct Indented {
  public let title: String?
  public let prefix: String
  public let content: [any StringConvertible]
  
  public init(
    _ title: String? = nil,
    prefix: String = "  | ",
    @DisplayStringBuilder _ content: () -> [any StringConvertible]
  ) {
    self.title = title
    self.prefix = prefix
    self.content = content()
  }
}

extension Indented: StringConvertible {
  public var stringValue: String {
    let indentedItems = content.map { prefix + $0.stringValue }
      .joined(separator: "\n")
    guard let title else {
      return indentedItems
    }
    return title + "\n" + indentedItems
  }
}
