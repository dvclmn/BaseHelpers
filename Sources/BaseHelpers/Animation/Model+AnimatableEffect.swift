//
//  Model+Effect.swift
//  AnimationVisualiser
//
//  Created by Dave Coleman on 22/11/2024.
//

import SwiftUI

/// List of Effects for possible future support

public protocol AnimatableEffect: Documentable {
  /// This is simple. Can just be one of `CGSize`, `CGFloat`, or `Angle`
  associatedtype Value: EffectValue

  static var kind: EffectKind { get }

  /// How strong should the Wave-driven effect be?
  var intensity: Value { get }
  init(fromValue value: Value)

  /// `WaveComposition` allows support for multiple Waves per Effect,
  /// and produces a final float wave value, to use to generate
  /// the below `output` value
  var waveComposition: WaveComposition { get set }

  /// This is the output after transformation using the wave value
  func output(elapsed: CGFloat, waveLibrary: [Wave]) -> Value

}


public protocol EffectValue {
  static var outputKind: EffectOutputKind { get }
  static func * (lhs: Self, rhs: CGFloat) -> Self
}
extension CGFloat: EffectValue {
  public static var outputKind: EffectOutputKind { .scalar }
}
extension CGSize: EffectValue {
  public static var outputKind: EffectOutputKind { .size }
}
extension Angle: EffectValue {
  public static var outputKind: EffectOutputKind { .angle }
}

/// Below three protocols added complexity without clear benefit
//public protocol ScalarEffect: EffectOutput {
//  var value: CGFloat { get }
//  init(_ amount: CGFloat)
//}
//
//public protocol SizeEffect: EffectOutput {
//  var value: CGSize { get }
//  init(w width: CGFloat, h height: CGFloat)
//}
//
//public protocol AngleEffect: EffectOutput {
//  var value: Angle { get }
//  init(_ angle: Angle)
//}

//// MARK: - Rotation
//public struct RotationEffect: AnimatableEffect, AngleEffect {
//  let angle: Angle
//
//  public var value: Angle { angle }
//
//  public init(_ angle: Angle) {
//    self.angle = angle
//  }
//
//  public static let zero = RotationEffect(.zero)
//
//  var degrees: CGFloat { angle.degrees }
//
//  public func waveDrivenProperty() -> WaveDrivenProperty<Angle> {
//    WaveDrivenProperty(scale: angle.degrees) { .degrees(Double($0)) }
//  }
//}
//

//// MARK: - Blur
//public struct BlurEffect: AnimatableEffect, ScalarEffect {
//  let amount: CGFloat
//
//  public init(_ amount: CGFloat) {
//    self.amount = amount
//  }
//
//  public var value: CGFloat { amount }
//  public static let zero = BlurEffect(.zero)
//
//  public func waveDrivenProperty() -> WaveDrivenProperty<CGFloat> {
//    WaveDrivenProperty(scale: amount) { $0 }
//  }
//}

//extension RotationEffect {
//
//}
//
//extension OffsetEffect {
//
//}
//
//extension ScaleEffect {
//
//}
//
//extension BlurEffect {
//
//}

//public struct AnimatedEffect<T> {
//  public let kind: EffectKind
//  public let waveValue: WaveDrivenProperty<T>
//
//  public init(
//    _ kind: EffectKind,
//    scale: CGFloat = 1,
//    offset: CGFloat = 0,
//  ) {
//    self.kind = kind
//    self.waveValue = WaveDrivenProperty(
//      scale: scale,
//      offset: offset,
//    )
//  }
//}

//protocol Effect {
//
//}
//
//
//public struct ScalarEffect {
//  let effect: AnimatedEffect
//  let amount: CGFloat
//}

//  case rotation(maxDegrees: CGFloat = 45)
//  case offset(x: CGFloat = 0, y: CGFloat = 50)
//  case scale(base: CGFloat = 1, amount: CGFloat = 0.2)
//  case skew(x: CGFloat = 0, y: CGFloat = 0)
//  case hue(maxDegrees: CGFloat = 180)
//  case blur(max: CGFloat = 10)
//  case opacity(base: CGFloat = 1, amount: CGFloat = 0.5)
//  case brightness(max: CGFloat = 0.5)

//public enum AnimatedEffect {
//}

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
