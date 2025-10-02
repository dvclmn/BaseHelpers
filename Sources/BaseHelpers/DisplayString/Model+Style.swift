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
  
  var labelStyle: ValueLabelStyle? {
    switch self {
      case .labels(let style): style
      case .plain: nil
    }
  }
  
//  public func string(for propertyLabels: [DisplayString.PropertyLabel]) -> [String] {
//    
//    let labelStrings = propertyLabels.map { labelStyle?.isFull ? $0.full : $0.abbreviated }
//  }
//  public var isShowingLabels: Bool { self == .labels() }
}


public enum ValueLabelStyle: Equatable {
  case abbreviated
  case full
  
  public var isFull: Bool { self == .full }
}
