//
//  Model+ScaleEffect.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/8/2025.
//

import Foundation

public struct ScaleEffect: AnimatableEffect {
  
  let width: CGFloat
  let height: CGFloat
  public var composition: WaveComposition = .init()
  
  public init(
    w width: CGFloat = 1,
    h height: CGFloat = 1
  ) {
    self.width = width
    self.height = height
  }
  //  public init(_ size: CGSize) {
  //    self.width = size.width
  //    self.height = size.height
  //  }
  public init(fromValue value: CGSize) {
    //    guard let result = value as? CGSize else {
    //      fatalError("Unsupported Value for \(Self.kind)")
    //    }
    self.init(w: value.width, h: value.height)
  }
  
  public static var kind: EffectKind { .scale }
  //  public static let kind = EffectKind.scale
  public var value: CGSize { CGSize(width: width, height: height) }
  public static let zero = Self(w: .zero, h: .zero)
  
  public func evaluate(withWaveValue value: CGFloat) -> CGSize {
    return CGSize(width: value * width, height: value * height)
  }
}
