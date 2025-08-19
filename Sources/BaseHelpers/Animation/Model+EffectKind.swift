//
//  Model+EffectKind.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 16/8/2025.
//

import SwiftUI

public enum EffectKind: String, CaseIterable, Identifiable, Documentable {

  //  case rotation
  case offset
  case scale
  case blur
  //  case skew
  //  case hue
  //  case opacity
  //  case brightness

  public init(fromAnyEffect effect: AnyEffect) {
    self =
      switch effect {
        case .offset(_): .offset
        case .scale(_): .scale
        case .blur(_): .blur
      }

  }

  public var id: String {
    self.name
  }

  
  //  public func createBlankValue() -> AnyEffectOutput {
  //    switch self {
  //      case .offset: AnyEffectOutput.create(fromSize: .zero)
  //      case .scale: AnyEffectOutput.create(fromSize: CGSize(width: 1.0, height: 1.0))
  //      case .blur: AnyEffectOutput.create(fromAngle: .zero)
  //    }
  //  }

  public var outputKind: EffectOutputKind {
    switch self {
      case .offset: .size
      case .scale: .size
      case .blur: .scalar
    }
  }

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
