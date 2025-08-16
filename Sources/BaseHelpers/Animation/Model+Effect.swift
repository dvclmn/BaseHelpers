//
//  Model+Effect.swift
//  AnimationVisualiser
//
//  Created by Dave Coleman on 22/11/2024.
//

import SwiftUI

public protocol AnimatableEffect: Documentable {
  associatedtype Value
  static var zero: Self { get }
  func waveValue() -> WaveDrivenProperty<Value>
}

// MARK: - Offset
public struct OffsetEffect: AnimatableEffect {

  let x: CGFloat
  let y: CGFloat

  public init(x: CGFloat, y: CGFloat) {
    self.x = x
    self.y = y
  }

  public static let zero = OffsetEffect(x: .zero, y: .zero)

  public func waveValue() -> WaveDrivenProperty<CGSize> {
    WaveDrivenProperty(scale: 1) { value in
      CGSize(width: value * x, height: value * y)
    }
  }
}

// MARK: - Rotation
public struct RotationEffect: AnimatableEffect {
  let angle: Angle

  public init(_ angle: Angle) {
    self.angle = angle
  }

  public static let zero = RotationEffect(.zero)

  var degrees: CGFloat { angle.degrees }

  public func waveValue() -> WaveDrivenProperty<Angle> {
    WaveDrivenProperty(scale: angle.degrees) { .degrees(Double($0)) }
  }
}

// MARK: - Scale
public struct ScaleEffect: AnimatableEffect {
  let amount: CGFloat

  public static let zero = ScaleEffect(.zero)

  public init(_ amount: CGFloat) {
    self.amount = amount
  }
  public func waveValue() -> WaveDrivenProperty<CGFloat> {
    WaveDrivenProperty(scale: amount, offset: 1) { $0 }
  }
}

// MARK: - Blur
public struct BlurEffect: AnimatableEffect {
  let amount: CGFloat

  public init(_ amount: CGFloat) {
    self.amount = amount
  }

  public static let zero = BlurEffect(.zero)

  public func waveValue() -> WaveDrivenProperty<CGFloat> {
    WaveDrivenProperty(scale: amount) { $0 }
  }
}

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
