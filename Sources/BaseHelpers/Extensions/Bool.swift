//
//  Boolean.swift
//  Collection
//
//  Created by Dave Coleman on 28/10/2024.
//

import SwiftUI

public enum BooleanDisplayFormat {
  case yesNo
  case onOff
  case enabledDisabled
  case checkmark
  case eye
  case activeInactive
  case custom(trueText: String, falseText: String)

  public func format(_ value: Bool) -> String {
    switch self {
      case .yesNo:
        return value ? "Yes" : "No"

      case .onOff:
        return value ? "On" : "Off"

      case .enabledDisabled:
        return value ? "Enabled" : "Disabled"

      case .checkmark:
        return value ? "􀆅" : "􀆄"

      case .eye:
        return value ? "􀋭" : "􀋯"

      case .activeInactive:
        return value ? "Active" : "Inactive"

      case .custom(let trueText, let falseText):
        return value ? trueText : falseText
    }
  }
}

extension Bool {
  public func displayAs(_ format: BooleanDisplayFormat) -> String {
    format.format(self)
  }

  public func displayAs(trueText: String, falseText: String) -> String {
    BooleanDisplayFormat.custom(trueText: trueText, falseText: falseText).format(self)
  }
  
  public func conditionalColour(
    isTrue trueColour: AnyShapeStyle?,
    otherwise fallback: AnyShapeStyle,
  ) -> AnyShapeStyle {
    self ? (trueColour ?? fallback) : fallback
  }
}
