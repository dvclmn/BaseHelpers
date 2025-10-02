//
//  MultiLine.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/10/2025.
//

import Foundation

@resultBuilder
struct MultiLineBuilder {
  public static func buildBlock(_ components: String...) -> String {
    components.joined(separator: "\n")
  }

  /// Handle optional strings
  static func buildOptional(_ component: String?) -> String {
    component ?? ""
  }

  /// Handle either/or conditions
  static func buildEither(first component: String) -> String {
    component
  }

  static func buildEither(second component: String) -> String {
    component
  }

  /// Handle arrays of strings
  static func buildArray(_ components: [String]) -> String {
    components.joined(separator: "\n")
  }
}

public struct MultiLine {
  let separator: String
  let content: String

  init(
    separator: String = "\n",
    @MultiLineBuilder content: () -> String
  ) {
    self.separator = separator
    self.content = content()
  }
}

extension MultiLine: CustomStringConvertible {
  public var description: String { content }
}
