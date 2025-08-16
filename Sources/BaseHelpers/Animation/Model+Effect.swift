//
//  Model+Effect.swift
//  AnimationVisualiser
//
//  Created by Dave Coleman on 22/11/2024.
//

import SwiftUI

struct AnimatedEffect {
  let kind: AnimatedEffectKind
  
}

//protocol Effect {
//  
//}
//
//
//public struct ScalarEffect {
//  let effect: AnimatedEffect
//  let amount: CGFloat
//}


//  public func drivenProperty() -> AnyAnimatedEffect {
//    switch self {
//      case .rotation(let maxDegrees):
//        return AnyAnimatedEffect(
//          WaveDrivenProperty(scale: maxDegrees) { Angle.degrees(Double($0)) }
//        )
//
//      case .offset(let x, let y):
//        return AnyAnimatedEffect(
//          WaveDrivenProperty(scale: 1) { value in
//            CGSize(width: value * x, height: value * y)
//          }
//        )
//
//      case .scale(let base, let amount):
//        return AnyAnimatedEffect(
//          WaveDrivenProperty(scale: amount, offset: base) { $0 }
//        )
//
//      case .skew(let x, let y):
//        return AnyAnimatedEffect(
//          WaveDrivenProperty(scale: 1) { value in
//            CGSize(width: value * x, height: value * y)
//          }
//        )
//
//      case .hue(let maxDegrees):
//        return AnyAnimatedEffect(
//          WaveDrivenProperty(scale: maxDegrees) { Angle.degrees(Double($0)) }
//        )
//
//      case .blur(let max):
//        return AnyAnimatedEffect(
//          WaveDrivenProperty(scale: max) { $0 }
//        )
//
//      case .opacity(let base, let amount):
//        return AnyAnimatedEffect(
//          WaveDrivenProperty(scale: amount, offset: base) { $0 }
//        )
//
//      case .brightness(let max):
//        return AnyAnimatedEffect(
//          WaveDrivenProperty(scale: max) { $0 }
//        )
//    }
//  }

//public enum AnimatedEffect {
//}

public enum AnimatedEffectKind: CaseIterable, Identifiable, Documentable {

//  public static let allCases: [AnimatedEffect] = [
//    .rotation(),
//    .offset(),
//    .scale(),
//    .skew(),
//    .hue(),
//    .blur(),
//    .opacity(),
//    .brightness(),
//  ]

//  case rotation(maxDegrees: CGFloat = 45)
//  case offset(x: CGFloat = 0, y: CGFloat = 50)
//  case scale(base: CGFloat = 1, amount: CGFloat = 0.2)
//  case skew(x: CGFloat = 0, y: CGFloat = 0)
//  case hue(maxDegrees: CGFloat = 180)
//  case blur(max: CGFloat = 10)
//  case opacity(base: CGFloat = 1, amount: CGFloat = 0.5)
//  case brightness(max: CGFloat = 0.5)

  
    case rotation
    case offset
    case scale
    case skew
    case hue
    case blur
    case opacity
    case brightness

  public var id: String {
    self.name
  }

  public var name: String {
    switch self {
      case .rotation: "Rotation"
      case .offset: "Offset"
      case .scale: "Scale"
      case .skew: "Skew"
      //      case .waveDistort: "Wave Distort"
      case .hue: "Hue Shift"
      case .blur: "Blur"
      case .opacity: "Opacity"
      case .brightness: "Brightness"
    }
  }

  public var icon: String {
    switch self {
      case .rotation: "angle"
      case .offset: "arrow.up.and.down.and.arrow.left.and.right"  // angle
      case .scale: "inset.filled.bottomleading.rectangle"
      case .skew: "skew"
      //      case .waveDistort: "water.waves"
      case .hue: "rainbow"
      case .blur: "drop"  // circle.dotted
      case .opacity: "circle.dotted.and.circle"
      case .brightness: "sun.max.fill"
    }
  }

  public var swatch: Swatch {
    switch self {

      case .rotation: .green20
      case .offset: .blue30
      case .scale: .purple40
      case .skew: .yellow40
      //      case .waveDistort: .red50
      case .hue: .purple70
      case .blur: .peach30
      case .opacity: .brown40
      case .brightness: .teal30
    }
  }


  //  public var dimensions: Set<EffectDimension> {
  //    switch self {
  //      case .rotation: [.degrees]
  //      case .offset: [.horizontal, .vertical]
  //      case .scale: [.horizontal, .vertical]
  //      case .skew: [.horizontal, .vertical]
  //      case .waveDistort: [.count, .speed, .strength]
  //      case .hue: [.degrees]
  //      case .blur: [.strength]
  //      case .opacity: [.strength]
  //      case .brightness: [.strength]
  //    }
  //  }

  /// `AmplificationStrategy` overlaps with `WaveDrivenProperty`'s
  /// scale/offset/transform — has been retired in favour of that cleaner mechanism.
  //  public var amplificationStrategy: AmplificationStrategy {
  //    switch self {
  //      case .rotation: .rotation
  //      case .offset: .basic
  //      case .scale: .scale
  //      case .skew: .basic
  //      case .waveDistort: .basic
  //      case .hue: .rotation
  //      case .blur: .basic
  //      case .opacity: .scale
  //      case .brightness: .basic
  //    }
  //  }

  //  public var modifierString: String {
  //    switch self {
  //      case .rotation: ".rotationEffect"
  //      case .offset: ".offset"
  //      case .scale: ".scaleEffect"
  //      case .skew: ""
  ////      case .waveDistort: ""
  //      case .hue: ".hue"
  //      case .blur: ".blur"
  //      case .opacity: ".opacity"
  //      case .brightness: ".brightness"
  //    }
  //  }

}

//public enum AmplificationStrategy {
//  case basic
//  case scale
//  case rotation
//
//  public func calculateAmplitude(_ value: Double, strength: Double = 1.0) -> Double {
//    switch self {
//      case .basic:
//        value * strength
//
//      case .scale:
//        1.0 + (value * strength)
//
//      case .rotation:
//        value * 360
//    }
//  }
//}
