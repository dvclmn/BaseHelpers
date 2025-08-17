//
//  Model+AnyAnimatedEffect.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 16/8/2025.
//

import SwiftUI

public enum AnyEffect: Documentable, Identifiable {
  //  case rotation(RotationEffect)
  case offset(OffsetEffect)
  case scale(ScaleEffect)
  case blur(BlurEffect)

  public var id: EffectKind {
    switch self {
      //      case .rotation: return .rotation
      case .offset: return .offset
      case .scale: return .scale
      case .blur: return .blur
    }
  }
  
  public init(fromEffect effect: any AnimatableEffect) {
    
    self = if let result = effect as? OffsetEffect {
      AnyEffect.offset(result)
    } else if let result = effect as? ScaleEffect {
      AnyEffect.scale(result)
    } else if let result = effect as? BlurEffect {
      AnyEffect.blur(result)
    } else {
      fatalError("Undefined effect")
    }
    
//    guard let result = effect as? BlurEffect else { fatalError("Unexpected blur effect")
//    }
//    AnyEffect.blur(result)
//    
//    let effectResult = switch effect.kind {
//      case .blur:
//        guard let result = effect as? BlurEffect else { fatalError("Unexpected blur effect")
//        }
//        AnyEffect.blur(result)
//        
//      case .offset:
//        guard let result = effect as? OffsetEffect else { fatalError("Unexpected blur effect")
//        }
//        AnyEffect.blur(result)
//        
//      case .scale:
//        guard let result = effect as? ScaleEffect else { fatalError("Unexpected blur effect")
//        }
//        AnyEffect.blur(result)
//    }
//    switch effect as? 
    
  }

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

  public var value: Any {
    //    precondition(self.kind.outputType == .scalar, "Cannot get scalar value for non-scalar effect.")
    //    guard let output = effect.value as? CGFloat else { return .zero }
    return effect.value
  }

  public var scalarValue: CGFloat {
    precondition(self.kind.outputType == .scalar, "Cannot get scalar value for non-scalar effect.")
    guard let output = effect.value as? CGFloat else { return .zero }
    return output
  }

  public var sizeValue: CGSize {
    precondition(self.kind.outputType == .size, "Cannot get size value for non-size effect.")
    guard let output = effect.value as? CGSize else { return .zero }
    return output
  }

  public var angleValue: Angle {
    precondition(self.kind.outputType == .size, "Cannot get angle value for non-angle effect.")
    guard let output = effect.value as? Angle else { return .zero }
    return output
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
