//
//  Model+EffectKind.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 16/8/2025.
//

import SwiftUI

public protocol EffectContainer {
  var effects: Effects { get set }
}

public struct Effects: Documentable {
  
  public var all: [any AnimatableEffect] {
    [offset, scale, blur]
  }
  
  public var enabled: [any AnimatableEffect] {
    all.filter { $0.isEnabled }
  }
  
  public var offset: WaveDrivenProperty<CGSize> = .empty
  public var scale: WaveDrivenProperty<CGSize> = .empty
  public var blur: WaveDrivenProperty<CGFloat> = .empty
  
//  public var offset: OffsetEffect = .empty
//  public var scale: ScaleEffect = .empty
//  public var blur: BlurEffect = .empty
  
  public init() {}
}

public enum EffectKind: String, CaseIterable, Identifiable, Documentable {

  //  case rotation
  case offset
  case scale
  case blur
  //  case skew
  //  case hue
  //  case opacity
  //  case brightness

  //  public init(fromAnyEffect effect: AnyEffect) {
  //    self =
  //      switch effect {
  //        case .offset(_): .offset
  //        case .scale(_): .scale
  //        case .blur(_): .blur
  //      }
  //
  //  }

//  static func create<T: AnimatableEffect>(
//    kind: EffectKind,
//    effectType: T.Type,
//    value: T.Intensity? = nil,
//    isEnabled: Bool = false
//  ) -> T {
//    switch kind {
//      case .offset:
//        OffsetEffect(withIntensity: value, isEnabled: isEnabled)
//      case .scale:
//        ScaleEffect(withIntensity: value, isEnabled: isEnabled)
//      case .blur:
//        BlurEffect(withIntensity: value, isEnabled: isEnabled)
//    }
//  }

  
//  public var effectType: (any AnimatableEffect).Type {
//    
//  }
  
  public var id: String {
    self.name
  }
  
//  public var defaultValue: any WaveOutput {
//    switch self {
//      case .offset:
//      case .scale:
//      case .blur:
//    }
//  }
  
  
//  public var keyPath: WritableKeyPath<any EffectContainer, any AnimatableEffect> {
////  public func keyPath<T: AnimatableEffect>() -> WritableKeyPath<any EffectContainer, T> {
////  public func keyPath<C: EffectContainer, T: AnimatableEffect>() -> WritableKeyPath<C, T> {
//    switch self {
//      case .offset: \.effects.offset
//      case .scale: \.effects.scale
//      case .blur: \.effects.blur
//    }
//  }
//  public var keyPath:
  
//  public func createEmptyEffect<T: AnimatableEffect>() -> T {
//    return T.default
//  }
  
//  public func createEffect<T: AnimatableEffect>(
//    withIntensity value: T.Value? = nil
//  ) -> T {
//    let newValue = value ?? T.empty.intensity
////    guard let newValue = value else {  }
//    return T.init(withIntensity: newValue)
////    switch self {
////      case .offset:
////        OffsetEffect(withValue: value)
////      case .scale:
////        <#code#>
////      case .blur:
////        <#code#>
////    }
////    return T.default
//    //    switch self {
//    //      case .offset: OffsetEffect()
//    //      case .scale: ScaleEffect()
//    //      case .blur: BlurEffect()
//    //    }
//  }
  
  public var effectType: any AnimatableEffect.Type {
    switch self {
      case .offset: OffsetEffect.self
      case .scale: ScaleEffect.self
      case .blur: BlurEffect.self
    }
  }

  //  public func createBlankValue() -> AnyEffectOutput {
  //    switch self {
  //      case .offset: AnyEffectOutput.create(fromSize: .zero)
  //      case .scale: AnyEffectOutput.create(fromSize: CGSize(width: 1.0, height: 1.0))
  //      case .blur: AnyEffectOutput.create(fromAngle: .zero)
  //    }
  //  }

  //  public var outputKind: EffectOutputKind {
  //    switch self {
  //      case .offset: .size
  //      case .scale: .size
  //      case .blur: .scalar
  //    }
  //  }

  public var scalarRange: ClosedRange<CGFloat> {
    return 0...100
  }

  public var name: String {
    switch self {
      //      case .rotation: "Rotation"
      case .offset: "Offset"
      case .scale: "Scale"
      case .blur: "Blur"
    //      case .skew: "Skew"
    //        //      case .waveDistort: "Wave Distort"
    //      case .hue: "Hue Shift"
    //      case .opacity: "Opacity"
    //      case .brightness: "Brightness"
    }
  }

  public var icon: String {
    switch self {
      //      case .rotation: "angle"
      case .offset: "arrow.up.and.down.and.arrow.left.and.right"  // angle
      case .scale: "inset.filled.bottomleading.rectangle"
      case .blur: "drop"  // circle.dotted
    //      case .skew: "skew"
    //        //      case .waveDistort: "water.waves"
    //      case .hue: "rainbow"
    //      case .opacity: "circle.dotted.and.circle"
    //      case .brightness: "sun.max.fill"
    }
  }

  public var swatch: Swatch {
    switch self {

      //      case .rotation: .green20
      case .offset: .blue30
      case .scale: .purple40
      case .blur: .peach30
    //      case .skew: .yellow40
    //        //      case .waveDistort: .red50
    //      case .hue: .purple70
    //      case .opacity: .brown40
    //      case .brightness: .teal30
    }
  }

}
