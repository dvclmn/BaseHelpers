//
//  Model+Effect.swift
//  AnimationVisualiser
//
//  Created by Dave Coleman on 22/11/2024.
//

import SwiftUI

public protocol EffectValue {
  static var zero: Self { get }
}
extension CGFloat: EffectValue {
}
extension CGSize: EffectValue {
}
extension Angle: EffectValue {
}

public protocol AnimatableEffect: Documentable {
  associatedtype Value: EffectValue
  var value: Value { get }
  static var kind: EffectKind { get }
  func evaluate(withWaveValue value: CGFloat) -> Value
  init(fromValue value: EffectValue)
}
extension AnimatableEffect {
  //  public static var typeName: String {  }
  //  public init(fromValue value: EffectValue) {
  //    if let result = value as? CGFloat {
  //      OffsetEffect(result)
  //      //        AnyEffect.offset(result)
  //    } else if let result = value as? CGSize {
  //      AnyEffect.scale(result)
  //    } else if let result = value as? Angle {
  //      AnyEffect.blur(result)
  //    } else {
  //      fatalError("Undefined effect")
  //    }
  //
  //    let effectResult =
  //      switch self.kind {
  //        case .offset:
  //          guard let result = value as? CGSize else {
  //            fatalError("Unsupported Value for OffsetEffect")
  //          }
  //          OffsetEffect(result)
  //
  //        case .scale:
  //        case .blur:
  //      }
  //  }
}
//extension AnimatableEffect where Value == CGSize {
//  public static var zero: Self { Self }
//}

// MARK: - Offset
public struct OffsetEffect: AnimatableEffect {

  let width: CGFloat
  let height: CGFloat

  public init(w width: CGFloat, h height: CGFloat) {
    self.width = width
    self.height = height
  }
  public init(_ size: CGSize) {
    self.width = size.width
    self.height = size.height
  }
  public init(fromValue value: EffectValue) {
    guard let result = value as? CGSize else {
      fatalError("Unsupported Value for \(Self.kind)")
    }
    self.init(result)
  }

  public static var kind: EffectKind { .offset }
  public var value: CGSize { CGSize(width: width, height: height) }
  public static let zero = Self(w: .zero, h: .zero)

  public func evaluate(withWaveValue value: CGFloat) -> CGSize {
    return CGSize(width: value * width, height: value * height)
  }
}

// MARK: - Scale
public struct ScaleEffect: AnimatableEffect {

  let width: CGFloat
  let height: CGFloat

  public init(w width: CGFloat, h height: CGFloat) {
    self.width = width
    self.height = height
  }
  public init(_ size: CGSize) {
    self.width = size.width
    self.height = size.height
  }
  public init(fromValue value: EffectValue) {
    guard let result = value as? CGSize else {
      fatalError("Unsupported Value for \(Self.kind)")
    }
    self.init(result)
  }

  public static var kind: EffectKind { .scale }
  //  public static let kind = EffectKind.scale
  public var value: CGSize { CGSize(width: width, height: height) }
  public static let zero = Self(w: .zero, h: .zero)

  public func evaluate(withWaveValue value: CGFloat) -> CGSize {
    return CGSize(width: value * width, height: value * height)
  }
}

public struct BlurEffect: AnimatableEffect {

  let amount: CGFloat

  public init(_ amount: CGFloat) {
    self.amount = amount
  }
  public init(fromValue value: EffectValue) {
    guard let result = value as? CGFloat else {
      fatalError("Unsupported Value for \(Self.kind)")
    }
    self.init(result)
  }

  public var value: CGFloat { amount }
  public static var kind: EffectKind { .blur }
  //  public static let kind = EffectKind.scale
  public static let zero = Self(.zero)

  public func evaluate(withWaveValue value: CGFloat) -> CGFloat {
    return CGFloat(value * amount)
  }
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
