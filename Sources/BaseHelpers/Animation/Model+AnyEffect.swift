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
    //    switch effectKind {
    //      case .offset:
    //        guard let result = effectOutput.value as? CGSize else {
    //          fatalError("Value for \(effectKind) must be \(effectKind.outputType.type)")
    //        }
    //        self = .offset(OffsetEffect(fromValue: result))
    //
    //      case .scale:
    //        guard let result = effectOutput.value as? CGSize else {
    //          fatalError("Value for \(effectKind) must be \(effectKind.outputType.type)")
    //        }
    //        self = .scale(ScaleEffect(fromValue: result))
    //
    //      case .blur:
    //        guard let result = effectOutput.value as? CGFloat else {
    //          fatalError("Value for \(effectKind) must be \(effectKind.outputType.type)")
    //        }
    //        self = .blur(BlurEffect(fromValue: result))
    //
    //    }

    //    if let result = value as? CGFloat {
    //      /// Scalar
    //    } else if let result = value as? CGSize {
    //
    //    } else if let result = value as? Angle {
    //
    //    }
    //
    //    let effect: any AnimatableEffect =
    //      switch effectKind {
    //        case .offset: OffsetEffect(fromValue: value)
    //        case .scale: ScaleEffect(fromValue: value)
    //        case .blur: BlurEffect(fromValue: value)
    //      }
    //    self = AnyEffect(fromEffect: effect)
  }

  //  public init<T: AnimatableEffect>(
  //    effect: T,
  //    //    fromKind effectKind: EffectKind,
  //    withValue value: T.Value
  //  ) {
  //    //    let effect: any AnimatableEffect =
  //    //    switch effectKind {
  //    //      case .offset: OffsetEffect(fromValue: value)
  //    //      case .scale: ScaleEffect(fromValue: value)
  //    //      case .blur: BlurEffect(fromValue: value)
  //    //    }
  //    self = AnyEffect(fromEffect: effect)
  //  }

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

  //  public init(
  //    fromValue value: EffectValue,
  //    kind: EffectKind
  //  ) {
  //    /// Scalar
  //    if let result = value as? CGFloat {
  //
  //      AnyEffect.offset(result)
  //    } else if let result = value as? CGSize {
  //      AnyEffect.scale(result)
  //    } else if let result = value as? Angle {
  //      AnyEffect.blur(result)
  //    } else {
  //      fatalError("Undefined effect")
  //    }
  //  }

  //  public var base: any AnimatableEffect {
  //    switch self {
  //      //      case .rotation(let e): e
  //      case .offset(let e): e
  //      case .scale(let e): e
  //      case .blur(let e): e
  //    }
  //  }

  public var kind: EffectKind {
    return EffectKind(fromAnyEffect: self)
  }

  //  public static func createScalar(_ amount: CGFloat) -> Self {
  //
  //  }

  //  public func updateEffect() -> Self {
  //
  //  }

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

//  public var value: Any {
//    //    precondition(self.kind.outputType == .scalar, "Cannot get scalar value for non-scalar effect.")
//    //    guard let output = effect.value as? CGFloat else { return .zero }
//    return effect.value
//  }

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

  public func evaluate(withWaveValue waveValue: CGFloat) -> Any {
    return effect.evaluate(withWaveValue: waveValue)
    //    switch self {
    //      //      case .rotation(let effect):
    //      //        return effect.waveDrivenProperty().evaluate(withWaveValue: waveValue)
    //      case .offset(let effect): effect.evaluate(withWaveValue: waveValue)
    //      //        return effect.waveDrivenProperty().evaluate(withWaveValue: waveValue)
    //
    //      case .scale(let effect): effect.evaluate(withWaveValue: waveValue)
    //      //        return effect.waveDrivenProperty().evaluate(withWaveValue: waveValue)
    //
    //      case .blur(let effect): effect.evaluate(withWaveValue: waveValue)
    //    //        return effect.waveDrivenProperty().evaluate(withWaveValue: waveValue)
    //    }
  }
}
