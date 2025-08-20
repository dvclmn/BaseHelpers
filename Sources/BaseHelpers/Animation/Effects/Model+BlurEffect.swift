//
//  Model+BlurEffect.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/8/2025.
//

import Foundation

//public struct BlurEffect: AnimatableEffect {
//  public static var defaultIntensity: CGFloat { CGFloat.zero }
//
//  public static var kind: EffectKind { .blur }
//
//  public var intensity: CGFloat
//  public var isEnabled: Bool = false
//
//  public init(_ intensity: CGFloat) {
//    self.intensity = intensity
//  }
//  public init(withIntensity value: CGFloat) {
//    self.init(value)
//  }
//
//  public var waveComposition: WaveComposition = .empty
//
//  public init(
//    fromKind kind: EffectKind,
//    value: Intensity? = nil,
//    isEnabled: Bool = false
//  ) {
//    self.init(
//      withIntensity: value,
//      isEnabled: isEnabled
//    )
//  }
//  
//  public init(
//    withIntensity value: Intensity?,
//    isEnabled: Bool
//  ) {
//    self.intensity = value ?? Self.defaultIntensity
//    self.isEnabled = isEnabled
//  }
//}

//public struct BlurEffect: AnimatableEffect {
//
//  let amount: CGFloat
//  public var composition: WaveComposition = .init()
//
//  public init(_ amount: CGFloat = .zero) {
//    self.amount = amount
//  }
//  public init(fromValue value: CGFloat) {
//    //    guard let result = value as? CGSize else {
//    //      fatalError("Unsupported Value for \(Self.kind)")
//    //    }
//    self.init(value)
//  }
//
//  public var value: CGFloat { amount }
//  public static var kind: EffectKind { .blur }
//  //  public static let kind = EffectKind.scale
//  public static let zero = Self(.zero)
//
//  public func evaluate(withWaveValue value: CGFloat) -> CGFloat {
//    return CGFloat(value * amount)
//  }
//}
