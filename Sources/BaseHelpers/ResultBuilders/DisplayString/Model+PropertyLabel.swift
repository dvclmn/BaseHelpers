//
//  Model+DisplayPair.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/7/2025.
//

import Foundation

//extension DisplayString {
  public struct PropertyLabel {

    /// The standard / more verbose representation,
    /// e.g. `Width` for `CGSize`
    let label: String

    /// A more concise version, such as `W` instead of `Width`
    let abbreviated: String

    public init(_ label: String, abbreviated: String? = nil) {
      self.label = label
      self.abbreviated = abbreviated ?? label
    }

    public init(_ label: String, _ abbreviated: String) {
      self.label = label
      self.abbreviated = abbreviated
    }
  }
//}

/// Enables 'skipping'
extension PropertyLabel: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    self.init(value)
  }
}
