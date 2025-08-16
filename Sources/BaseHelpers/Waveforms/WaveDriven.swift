//
//  WaveDrive.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 16/8/2025.
//

import SwiftUI

/// Aka: given a scalar wave, here’s how to turn it into something else
/// The adapter pattern between “wave = CGFloat” and “typed animation property”

//public protocol WaveGenerated {
//
//}

//public typealias WaveOutput<T: WaveGenerated> = (CGFloat) -> T

//public struct WaveDrivenProperty<T> where T: WaveGenerated {
public struct WaveDrivenProperty<T> {

//  let kind: EffectKind

  /// Note: Without `transform`, `WaveDrivenProperty` would only
  /// ever output `CGFloat`. That’s too limiting — we want Angle, CGSize,
  /// even Color, etc...
  let transform: (CGFloat) -> T
  let scale: CGFloat
  let offset: CGFloat

  public init(
//    kind: EffectKind,
    scale: CGFloat = 1,
    offset: CGFloat = 0,
    transform: @escaping (CGFloat) -> T
  ) {
//    self.kind = kind
    self.scale = scale
    self.offset = offset
    self.transform = transform
  }

  func evaluate(with rawValue: CGFloat) -> T {
    transform(rawValue * scale + offset)
  }
}

//extension WaveDrivenProperty where T: BinaryFloatingPoint {
////  public static func scalar(scale: T = 1, offset: T = 0) -> Self {
////    .init(
////            kind: .
////      scale: CGFloat(scale),
////      offset: CGFloat(offset)
////    ) { T($0) }
////  }
//
//  public static func scale(
//    around base: T = 1,
//    amount: T
//  ) -> Self {
//    .init(
////      kind: .scale,
//      scale: CGFloat(amount),
//      offset: CGFloat(base)
//    ) { T($0) }
//  }
//}
//
//extension WaveDrivenProperty where T == CGSize {
//  public static func offsetX(scale: CGFloat = 1) -> Self {
//    .init(
//      scale: scale
//    ) { CGSize(width: $0, height: 0) }
//  }
//
//  public static func offsetY(scale: CGFloat = 1) -> Self {
//    .init(scale: scale) { CGSize(width: 0, height: $0) }
//  }
//}
//
//extension WaveDrivenProperty where T == Angle {
//  public static func rotation(degrees scale: CGFloat = 1) -> Self {
//    .init(
//      scale: scale
//    ) { .degrees(Double($0)) }
//  }
//}
