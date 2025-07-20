//
//  Model+DisplayStringConfig.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/7/2025.
//

import Foundation

public enum ValueDisplayStyle: Equatable {
  case labels(ValueLabelStyle = .abbreviated)
  case plain
  
  public var isShowingLabels: Bool { self == .labels(.abbreviated) || self == .labels(.full) }
}

public enum ValueLabelStyle: Equatable {
  case abbreviated
  case full
}
