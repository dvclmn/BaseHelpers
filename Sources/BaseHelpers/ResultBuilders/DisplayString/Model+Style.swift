//
//  Model+DisplayStringConfig.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/7/2025.
//

import Foundation

extension DisplayString {
  
  public enum ValueLabelStyle: Equatable {
    case abbreviated
    case full
    
    public var isFull: Bool { self == .full }
  }

  @available(
    *, deprecated,
    message: "Favour omitting the `label` property on `DisplayString.Component`, to represent 'plain'."
  )
  public enum ValueDisplayStyle: Equatable {
    case labels(ValueLabelStyle = .abbreviated)

    /// I think plain could be covered (replaced) by the
    /// optionality of the `DisplayString/Component/label`
    /// property. Omitting this  == `plain`.
    case plain

    var labelStyle: ValueLabelStyle? {
      switch self {
        case .labels(let style): style
        case .plain: nil
      }
    }
  }

  
}
