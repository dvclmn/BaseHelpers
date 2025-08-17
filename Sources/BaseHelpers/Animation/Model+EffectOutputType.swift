//
//  Model+EffectOutputType.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/8/2025.
//

import SwiftUI

public enum AnyEffectOutput: Equatable, Hashable {
  case scalar(CGFloat = .zero)
  case size(CGSize = .zero)
  case angle(Angle = .zero)

//  public init(fromEffectKind kind: EffectKind) {
//    switch kind {
//      case .offset:
//        <#code#>
//      case .scale:
//        <#code#>
//      case .blur:
//        <#code#>
//    }
//  }
  
  public var type: Any.Type {
    switch self {
      case .scalar: CGFloat.self
      case .size: CGSize.self
      case .angle: Angle.self
    }
  }
  
  public var effectKinds: [EffectKind] {
    switch self {
      case .scalar: [.blur]
      case .size: [.offset, .scale]
      case .angle: []
    }
  }
}
