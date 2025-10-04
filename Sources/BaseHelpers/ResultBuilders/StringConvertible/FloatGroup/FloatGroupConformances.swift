//
//  FloatGroupConformances.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/10/2025.
//

import Foundation

extension CGPoint: FloatGroup {
  public var propertyLabelSeparator: String? { ": " }
  public var components: [Component] {
    [
      Component("X", value: self.x, separator: propertyLabelSeparator),
    ]
  }
}
