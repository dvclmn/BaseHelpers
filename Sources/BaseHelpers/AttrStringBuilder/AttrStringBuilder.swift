//
//  AttrStringBuilder.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 6/7/2025.
//

import Foundation
import SwiftUI

// MARK: - @AttrString function builder attribute
@resultBuilder
public struct AttrString {
  public static func buildBlock(_ components: AttributedString...) -> AttributedString {
    components.reduce(AttributedString(), +)
  }

  public static func buildArray(_ components: [AttributedString]) -> AttributedString {
    components.reduce(AttributedString(), +)
  }

  public static func buildOptional(_ component: AttributedString?) -> AttributedString {
    component ?? AttributedString()
  }

  public static func buildEither(first component: AttributedString) -> AttributedString {
    component
  }

  public static func buildEither(second component: AttributedString) -> AttributedString {
    component
  }

  public static func buildExpression(_ expression: AttributedString) -> AttributedString {
    expression
  }

  public static func buildExpression(_ expression: String) -> AttributedString {
    AttributedString(expression)
  }
}

// MARK: - StyledText typealias and extensions
typealias StyledText = AttributedString

extension AttributedString {
  public init(@AttrString _ content: () -> AttributedString) {
    self = content()
  }

  public func colour(_ colour: Color) -> AttributedString {
    var result = self
    result.foregroundColor = colour
    return result
  }

  public func fontStyle(_ font: Font) -> AttributedString {
    var result = self
    result.font = font
    return result
  }

  public func bold() -> AttributedString {
    var result = self
    result.inlinePresentationIntent = .stronglyEmphasized
    return result
  }

  public func italic() -> AttributedString {
    var result = self
    result.inlinePresentationIntent = .emphasized
    return result
  }

  public func underline() -> AttributedString {
    var result = self
    result.underlineStyle = .single
    return result
  }

  public func strikethrough() -> AttributedString {
    var result = self
    result.strikethroughStyle = .single
    return result
  }

  public func background(_ colour: Color) -> AttributedString {
    var result = self
    result.backgroundColor = colour
    return result
  }
}
