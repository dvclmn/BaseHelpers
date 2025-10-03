//
//  Model+DisplayString.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/10/2025.
//

import Foundation

/// Purely for namespace
public struct DisplayString {
  let components: [DisplayComponent]
  let separator: String

  public init(
    separator: String = " × ",
    @DisplayStringBuilder _ components: () -> String
//    @DisplayString.Builder _ components: () -> [DisplayComponent]
  ) {
    self.components = components().joi
    self.separator = separator
  }

  public init(components: [DisplayComponent], separator: String = " × ") {
    self.components = components
    self.separator = separator
  }
}
