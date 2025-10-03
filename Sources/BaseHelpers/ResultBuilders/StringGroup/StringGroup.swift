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

extension StringGroup: CustomStringConvertible {
  public var description: String { output }
}
