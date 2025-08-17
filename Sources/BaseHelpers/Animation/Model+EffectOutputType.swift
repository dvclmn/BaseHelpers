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

  public init(
    fromKind kind: EffectKind,
    withScalar scalar: CGFloat
  ) {
    self = switch kind {
      case .blur: .scalar(scalar)
      case .offset, .scale: fatalError("Wrong thing")
    }
  }
  public init(
    fromKind kind: EffectKind,
    withSize size: CGSize
  ) {
    self = switch kind {
      case .offset, .scale: .size(size)
      case .blur: fatalError("Wrong thing")
    }
  }
  public init(
    fromKind kind: EffectKind,
    withAngle angle: Angle
  ) {
    self = switch kind {
      case .blur, .offset, .scale: fatalError("Wrong thing")
//      case .offset, .scale: fatalError("Wrong thing")
    }
  }
  
  public var value: Any {
    switch self {
      case .scalar(let output): output
      case .size(let output): output
      case .angle(let output): output
    }
  }
  
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
