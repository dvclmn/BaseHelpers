//
//  Model+BlurEffect.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/8/2025.
//

public struct BlurEffect: AnimatableEffect {
  
  public static var kind: EffectKind { .blur }
  
  let intensity: CGFloat
//  let height: CGFloat
  
  public var waveComposition: WaveComposition = .empty
  
}

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
