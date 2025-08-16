//
//  WaveDrive.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 16/8/2025.
//

import SwiftUI

/// Aka: given a scalar wave, here’s how to turn it into something else
public struct WaveDrivenProperty<T> {
  
  /// Note: Without `transform`, `WaveDrivenProperty` would only
  /// ever output `CGFloat`. That’s too limiting — we want Angle, CGSize,
  /// even Color, etc...
  let transform: (CGFloat) -> T
  let scale: CGFloat
  let offset: CGFloat

  public init(
    scale: CGFloat = 1,
    offset: CGFloat = 0,
    transform: @escaping (CGFloat) -> T
  ) {
    self.scale = scale
    self.offset = offset
    self.transform = transform
  }

  func evaluate(with rawValue: CGFloat) -> T {
    transform(rawValue * scale + offset)
  }
}

extension WaveDrivenProperty where T == CGFloat {
  public static func scalar(scale: CGFloat = 1, offset: CGFloat = 0) -> Self {
    .init(scale: scale, offset: offset) { $0 }
  }

  public static func scale(around base: CGFloat = 1, amount: CGFloat) -> Self {
    .init(scale: amount, offset: base) { $0 }
  }
}

extension WaveDrivenProperty where T == CGSize {
  public static func offsetX(scale: CGFloat = 1) -> Self {
    .init(scale: scale) { CGSize(width: $0, height: 0) }
  }

  public static func offsetY(scale: CGFloat = 1) -> Self {
    .init(scale: scale) { CGSize(width: 0, height: $0) }
  }
}

extension WaveDrivenProperty where T == Angle {
  public static func rotation(degrees scale: CGFloat = 1) -> Self {
    .init(scale: scale) { .degrees(Double($0)) }
  }
}
