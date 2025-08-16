//
//  Model+AnyAnimatedEffect.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 16/8/2025.
//

import Foundation

public enum AnyEffect: Codable, Equatable, Identifiable {
  case rotation(RotationEffect)
  case offset(OffsetEffect)
  case scale(ScaleEffect)
  case blur(BlurEffect)

  public var id: EffectKind {
    switch self {
      case .rotation: return .rotation
      case .offset: return .offset
      case .scale: return .scale
      case .blur: return .blur
    }
  }
}

extension AnyEffect {
  public func evaluate(with raw: CGFloat) -> Any {
    switch self {
      case .rotation(let effect):
        return effect.drivenProperty().evaluate(with: raw)
      case .offset(let effect):
        return effect.drivenProperty().evaluate(with: raw)
      case .scale(let effect):
        return effect.drivenProperty().evaluate(with: raw)
      case .blur(let effect):
        return effect.drivenProperty().evaluate(with: raw)
    }
  }
}

//public struct AnyAnimatedEffect {
//  private let _evaluate: (CGFloat) -> Any
//  public init<T>(_ property: WaveDrivenProperty<T>) {
//    self._evaluate = { property.evaluate(with: $0) }
//  }
//  public func evaluate(with raw: CGFloat) -> Any {
//    _evaluate(raw)
//  }
//}
