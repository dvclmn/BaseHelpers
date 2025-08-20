//
//  Model+Effect.swift
//  AnimationVisualiser
//
//  Created by Dave Coleman on 22/11/2024.
//

import SwiftUI

public protocol WaveSource: Documentable {
  func value(elapsed: TimeInterval) -> CGFloat
}

/// List of Effects for possible future support
// MARK: - Protocols
public protocol AnimatableEffect: Documentable {
  associatedtype Intensity: EffectIntensity
  static var kind: EffectKind { get }
  static var defaultIntensity: Intensity { get }
  static var empty: Self { get }
  
  /// How strong should the final Wave-driven effect be?
  /// This will be multiplied by the `WaveComposition`'s value
  var intensity: Intensity { get set }
  var isEnabled: Bool { get set }
  var waveComposition: WaveComposition { get set }
  
  init(
    withIntensity value: Intensity?,
    isEnabled: Bool
  )
//  static func create(
//    fromKind kind: EffectKind,
//    value: Intensity?,
//    isEnabled: Bool
//  ) -> Self

  /// `WaveComposition` allows support for multiple Waves per Effect,
  /// and produces a final float wave value, to use to generate
  /// the below `output` value

  /// This is the output after transformation using the wave value
  func output(elapsed: CGFloat, waveLibrary: [Wave]) -> Intensity

}

public protocol EffectIntensity {

  //  static var outputKind: EffectOutputKind { get }
  //  init(_ value: Any)
  /// The below two are kind the same; tho tbf `evaluateIntensity()`
  /// does make use of the static `*` operator
  func evaluateIntensity(waveValue: CGFloat) -> Self
  static func * (lhs: Self, rhs: CGFloat) -> Self
}

// MARK: - Protocol Extensions

extension CGFloat: EffectIntensity {}
extension CGSize: EffectIntensity {}
extension Angle: EffectIntensity {}

/// Main extension
extension AnimatableEffect {

//  public var waveComposition: WaveComposition {
//    WaveComposition()
//  }

  

  public static var empty: Self { Self(withIntensity: Self.defaultIntensity, isEnabled: true) }

  //  public init(withIntensity value: Value = Self.defaultIntensity) {
  //    self.intensity = value
  //  }
  //  public init(withIntensity value: Self.Value = Self.default.intensity) {
  //    self.intensity = value
  //  }
  //  public init(fromAnyEffect effect: AnyEffect) {
  //    switch effect {
  //
  //    }
  //  }
  /// Uses `EffectIntensity`'s `*` operator to simplify
  /// implementation for generating final output
  public func output(
    elapsed: CGFloat,
    waveLibrary: [Wave]
  ) -> Self.Intensity {
    let waveValue = waveComposition.value(elapsed: elapsed, waveLibrary: waveLibrary)
    let result = intensity.evaluateIntensity(waveValue: waveValue)
    return result
  }
}

/// `AnimatableEffect` for `CGSize`
extension AnimatableEffect where Self.Intensity == CGSize {

}

/// `AnimatableEffect` for `CGFloat`
extension AnimatableEffect where Self.Intensity == CGFloat {

}

/// `AnimatableEffect` for `Angle`
extension AnimatableEffect where Self.Intensity == Angle {
  //  public init(_ rotation: CGFloat) {
  //    //    self.width = width
  //    self.rotation = rotation
  //  }
  //  public init(withIntensity value: Angle) {
  //    self.init(value)
  //  }

  //  public var intensity: Angle {  }
}

extension EffectIntensity {
  public func evaluateIntensity(waveValue: CGFloat) -> Self {
    self * waveValue
  }
}

//extension CGFloat: EffectIntensity {
//  public static var outputKind: EffectOutputKind { .scalar }
//}
//
//extension CGSize: EffectIntensity {
//  public static var outputKind: EffectOutputKind { .size }
//}
//
//extension Angle: EffectIntensity {
//  public static var outputKind: EffectOutputKind { .angle }
//}

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
