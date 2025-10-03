//
//  Model+DisplayString.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/10/2025.
//

import Foundation

/// Purely for namespace
public struct DisplayString<Value> where Value: FloatDisplay {
  let components: [Component]
  let separator: String
  
  public init(
    separator: String = " × ",
    @DisplayString.Builder _ components: () -> [Component]
  ) {
    self.components = components()
    self.separator = separator
  }
  
  public init(components: [Component], separator: String = " × ") {
    self.components = components
    self.separator = separator
  }
}
  
