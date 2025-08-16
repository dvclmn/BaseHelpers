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

  //  public init(fromKind kind: EffectKind) {
  //    self = switch kind {
  //      case .rotation: .rotation
  //      case .offset:
  //
  //      default: fatalError("EffectKind[\(kind)] not yet supported for AnyEffect")
  //    }
  //  }

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
  public func evaluate(withWaveValue waveValue: CGFloat) -> Any {
    switch self {
      case .rotation(let effect):
        return effect.waveDrivenProperty().evaluate(withWaveValue: waveValue)
      case .offset(let effect):
        return effect.waveDrivenProperty().evaluate(withWaveValue: waveValue)
      case .scale(let effect):
        return effect.waveDrivenProperty().evaluate(withWaveValue: waveValue)
      case .blur(let effect):
        return effect.waveDrivenProperty().evaluate(withWaveValue: waveValue)
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
