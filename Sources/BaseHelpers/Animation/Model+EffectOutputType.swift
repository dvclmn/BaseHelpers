//
//  Model+EffectOutputType.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/8/2025.
//

import Foundation

public enum EffectOutputType {
  case scalar
  case size
  case angle
  
  public var type: any EffectValue.Type {
    switch self {
      case .scalar: CGFloat.self
      case .size: CGSize.self
      case .angle: Angle.self
    }
  }
}
