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

//  public typealias Value = CGSize

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

public enum EffectKind: CaseIterable, Identifiable, Documentable {

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

  public var hasImplementation: Bool {
    switch self {
      case .rotation, .offset, .scale: true
      default: false
    }
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
