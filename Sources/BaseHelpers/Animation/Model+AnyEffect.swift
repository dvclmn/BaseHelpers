//
//  Model+AnyAnimatedEffect.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 16/8/2025.
//

import Foundation

public enum AnyEffect: Documentable, Identifiable {
  //  case rotation(RotationEffect)
  case offset(OffsetEffect)
//  case scale(ScaleEffect)
    case blur(BlurEffect)

  public init(fromKind kind: EffectKind) {
    self =
      switch kind {
        //        case .rotation: .rotation(.zero)
        case .offset: .offset(.zero)
//        case .scale: .scale(.zero)
              case .blur: .blur(.zero)
      //        default: fatalError("EffectKind[\(kind)] not yet supported for AnyEffect")
      }
  }

  public var id: EffectKind {
    switch self {
      //      case .rotation: return .rotation
      case .offset: return .offset
//      case .scale: return .scale
          case .blur: return .blur
    }

  }

  public var base: any AnimatableEffect {
    switch self {
      //      case .rotation(let e): e
      case .offset(let e): e
//      case .scale(let e): e
          case .blur(let e): e
    }
  }

  public func evaluate(withWaveValue waveValue: CGFloat) -> Any {
    switch self {
      //      case .rotation(let effect):
      //        return effect.waveDrivenProperty().evaluate(withWaveValue: waveValue)
      case .offset(let effect): effect.evaluate(withWaveValue: waveValue)
      //        return effect.waveDrivenProperty().evaluate(withWaveValue: waveValue)

//      case .scale(let effect): effect.evaluate(withWaveValue: waveValue)
    //        return effect.waveDrivenProperty().evaluate(withWaveValue: waveValue)

          case .blur(let effect): effect.evaluate(withWaveValue: waveValue)
    //        return effect.waveDrivenProperty().evaluate(withWaveValue: waveValue)
    }
  }
}
