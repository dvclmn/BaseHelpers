//
//  StringGroup.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/10/2025.
//

import Foundation

public struct StringGroup {
  let separator: String
  let content: [any StringConvertible]

  public init(
    separator: String = "\n",
    @StringGroupBuilder content: () -> [any StringConvertible]
  ) {
    self.separator = separator
    self.content = content()
  }
}
extension StringGroup {
  public var output: String {
    let stringValue = content.map { convertible in
      convertible.stringValue
    }.joined(separator: separator)

    return stringValue
  }
}

public struct Indented {
  public let prefix: String
  public let content: [any StringConvertible]

  public init(
    prefix: String = "  | ",
    @StringGroupBuilder _ content: () -> [any StringConvertible]
  ) {
    self.prefix = prefix
    self.content = content()
  }

}

public struct Labeled {
  public let key: String
  public let value: any StringConvertible
  public let separator: String

  public init(
    _ key: String,
    value: any StringConvertible,
    separator: String = ": "
  ) {
    self.key = key
    self.value = value
    self.separator = separator
  }
}
