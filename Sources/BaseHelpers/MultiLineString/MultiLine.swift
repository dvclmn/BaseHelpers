//
//  MultiLine.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/10/2025.
//

import Foundation


public struct MultiLine {
  let separator: String
  let content: [String]

  init(
    separator: String = "\n",
    @MultiLineBuilder content: () -> [String]
  ) {
    self.separator = separator
    self.content = content()
  }
}

extension MultiLine: CustomStringConvertible {
  public var description: String {
    content.joined(separator: separator)
  }
}
