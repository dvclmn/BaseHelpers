//
//  Model+EffectKind.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 16/8/2025.
//

import Foundation

//public enum EffectOutputType {
//  case scalar
//  case
//}

public enum EffectKind: String, CaseIterable, Identifiable, Documentable {
  
//  case rotation
  case offset
  case scale
//  case blur
//  case skew
//  case hue
//  case opacity
//  case brightness
  
  public init?(fromAnyEffect effect: AnyEffect) {
    let kind: EffectKind? = switch effect {
//      case .rotation(_): .rotation
      case .offset(_): .offset
      case .scale(_): .scale
//      case .blur(_): .blur
    }
    guard let kind else { return nil }
    self = kind
  }
  
  public var id: String {
    self.name
  }
  
  
  
//  public var hasImplementation: Bool {
//    switch self {
//      case .rotation, .offset, .scale: true
//      default: false
//    }
//  }
  
  public var name: String {
    switch self {
//      case .rotation: "Rotation"
      case .offset: "Offset"
      case .scale: "Scale"
//      case .blur: "Blur"
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
//      case .blur: "drop"  // circle.dotted
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
//      case .blur: .peach30
//      case .skew: .yellow40
//        //      case .waveDistort: .red50
//      case .hue: .purple70
//      case .opacity: .brown40
//      case .brightness: .teal30
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
