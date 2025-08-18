//
//  Model+AnyAnimatedEffect.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 16/8/2025.
//

import SwiftUI

public enum AnyEffect: Documentable, Identifiable {
  case offset(OffsetEffect)
  case scale(ScaleEffect)
  case blur(BlurEffect)

  public var id: EffectKind {
    switch self {
      case .offset: return .offset
      case .scale: return .scale
      case .blur: return .blur
    }
  }

  public init(
    fromKind effectKind: EffectKind,
    withValue effectOutput: AnyEffectOutput
  ) {

    switch effectKind {
      case .offset:
        let value = effectOutput.size
        let effect = OffsetEffect(fromValue: value)
        self = AnyEffect.offset(effect)

      case .scale:
        let value = effectOutput.size
        let effect = ScaleEffect(fromValue: value)
        self = AnyEffect.scale(effect)

      case .blur:
        let value = effectOutput.scalar
        let effect = BlurEffect(fromValue: value)
        self = AnyEffect.blur(effect)
    }
  }

  public init(fromEffect effect: any AnimatableEffect) {

    self =
      if let result = effect as? OffsetEffect {
        AnyEffect.offset(result)
      } else if let result = effect as? ScaleEffect {
        AnyEffect.scale(result)
      } else if let result = effect as? BlurEffect {
        AnyEffect.blur(result)
      } else {
        fatalError("Undefined effect")
      }
  }

  public var kind: EffectKind {
    return EffectKind(fromAnyEffect: self)
  }

  public var effect: any AnimatableEffect {
    switch self {
      case .offset(let effectValue): effectValue
      case .scale(let effectValue): effectValue
      case .blur(let effectValue): effectValue
    }
  }

  public var effectOutput: AnyEffectOutput {
    switch self {
      case .offset(let effect): AnyEffectOutput.size(effect.value)
      case .scale(let effect): AnyEffectOutput.size(effect.value)
      case .blur(let effect): AnyEffectOutput.scalar(effect.value)
    }
  }

  public var scalar: CGFloat {
    guard let result = self.effect.value as? CGFloat else {
      fatalError("Cannot obtain a scalar value from non-scalar Effect")
    }
    return result
  }

  public var size: CGSize {
    guard let result = self.effect.value as? CGSize else {
      fatalError("Cannot obtain a size value from non-size Effect")
    }
    return result
  }
  public var angle: Angle {
    guard let result = self.effect.value as? Angle else {
      fatalError("Cannot obtain a angle value from non-angle Effect")
    }
    return result
  }
}
