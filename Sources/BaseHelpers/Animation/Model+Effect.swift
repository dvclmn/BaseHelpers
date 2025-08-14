//
//  Model+Effect.swift
//  AnimationVisualiser
//
//  Created by Dave Coleman on 22/11/2024.
//

import BaseStyles
import SwiftUI

enum AnimatedEffect: String, CaseIterable, Identifiable, Documentable {
  case rotation
  case offset
  case scale
  case skew
  case waveDistort
  case hue
  case blur
  case opacity
  case brightness

  var id: String {
    self.rawValue
  }

  var name: String {
    switch self {
      case .rotation: "Rotation"
      case .offset: "Offset"
      case .scale: "Scale"
      case .skew: "Skew"
      case .waveDistort: "Wave Distort"
      case .hue: "Hue Shift"
      case .blur: "Blur"
      case .opacity: "Opacity"
      case .brightness: "Brightness"
    }
  }

  var icon: String {
    switch self {
      case .rotation: "angle"
      case .offset: "arrow.up.and.down.and.arrow.left.and.right"  // angle
      case .scale: "inset.filled.bottomleading.rectangle"
      case .skew: "skew"
      case .waveDistort: "water.waves"
      case .hue: "rainbow"
      case .blur: "drop"  // circle.dotted
      case .opacity: "circle.dotted.and.circle"
      case .brightness: "sun.max.fill"
    }
  }

  var swatch: Swatch {
    switch self {

      case .rotation: .green20
      case .offset: .blue30
      case .scale: .purple40
      case .skew: .yellow40
      case .waveDistort: .red50
      case .hue: .purple70
      case .blur: .peach30
      case .opacity: .brown40
      case .brightness: .teal30
    //      case .rotation: .greenAqua
    //      case .offset: .blueSky
    //      case .scale: .purpleEggplant
    //      case .skew: .yellowLemon
    //      case .waveDistort: .redMuted
    //      case .hue: .purpleHazy
    //      case .blur: .peach
    //      case .opacity: .brownHazel
    //      case .brightness: .greenSpearmint

    }
  }

  var dimensions: Set<EffectDimension> {
    switch self {
      case .rotation: [.degrees]
      case .offset: [.horizontal, .vertical]
      case .scale: [.horizontal, .vertical]
      case .skew: [.horizontal, .vertical]
      case .waveDistort: [.count, .speed, .strength]
      case .hue: [.degrees]
      case .blur: [.strength]
      case .opacity: [.strength]
      case .brightness: [.strength]
    }
  }

  var amplificationStrategy: AmplificationStrategy {
    switch self {
      case .rotation: .rotation
      case .offset: .basic
      case .scale: .scale
      case .skew: .basic
      case .waveDistort: .basic
      case .hue: .rotation
      case .blur: .basic
      case .opacity: .scale
      case .brightness: .basic
    }
  }

  var modifierString: String {
    switch self {
      case .rotation: ".rotationEffect"
      case .offset: ".offset"
      case .scale: ".scaleEffect"
      case .skew: ""
      case .waveDistort: ""
      case .hue: ".hue"
      case .blur: ".blur"
      case .opacity: ".opacity"
      case .brightness: ".brightness"
    }
  }

  //  var codeOutput: String {
  //    switch self {
  //      case .offset: ""
  //      case .rotation: ""
  //      case .scale: ""
  //      case .skew: ""
  //      case .waveDistort: """
  //      .visualEffect { [engine.value] (content, proxy) in
  //          content
  //            .distortionEffect(ShaderLibrary.complexWave(
  //              .float(time.timeIntervalSinceReferenceDate),
  //              .float2(proxy.size),
  //              .float(value(.waveDistortSpeed)),
  //              .float(value(.waveDistortStrength)),
  //              .float(value(.waveDistortCount))
  //            ), maxSampleOffset: proxy.size, isEnabled: isDistortionEnabled)
  //
  //        }
  //      """
  //      case .hue: ""
  //      case .blur: ""
  //      case .opacity: ""
  //    }
  //  }

}

enum AmplificationStrategy {
  case basic
  case scale
  case rotation

  func calculateAmplitude(_ value: Double, strength: Double = 1.0) -> Double {
    switch self {
      case .basic:
        value * strength

      case .scale:
        1.0 + (value * strength)

      case .rotation:
        value * 360
    }
  }
}
