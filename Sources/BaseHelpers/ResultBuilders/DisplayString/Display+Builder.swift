//
//  DisplayBuilder.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/10/2025.
//

import Foundation

@resultBuilder
public struct DisplayStringBuilder {
  public static func buildBlock(
    _ components: DisplayComponent...
  ) -> [DisplayComponent] {
    components
  }
  
  public static func buildArray(
    _ components: [DisplayComponent]
  ) -> [DisplayComponent] {
    components
  }
  
  public static func buildOptional(
    _ component: [DisplayComponent]?
  ) -> [DisplayComponent] {
    component ?? []
  }
  
  public static func buildEither(
    first component: [DisplayComponent]
  ) -> [DisplayComponent] {
    component
  }
  
  public static func buildEither(
    second component: [DisplayComponent]
  ) -> [DisplayComponent] {
    component
  }
}
