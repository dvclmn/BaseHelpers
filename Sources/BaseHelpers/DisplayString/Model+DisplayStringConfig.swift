//
//  Model+DisplayStringConfig.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/7/2025.
//

import Foundation

public enum ValueDisplayStyle {
  case labels
  case plain
  
  public var isShowingLabels: Bool { self == .labels }
}
