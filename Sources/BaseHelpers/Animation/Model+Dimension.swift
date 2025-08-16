//
//  Model+Dimension.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/8/2025.
//

import Foundation

/// Removing, as per GPT rec:
/// Does this enum actually help at call sites, or just add indirection?
/// Possible uses for EffectDimension:
/// - You could use it to auto-generate UI controls (sliders labelled “Horizontal” or “Degrees”).
/// - Or you could use it to document what knobs exist for each AnimatedEffect.
/// •  Or you could use it to validate/match WaveDrivenProperty configs to AnimatedEffect.
                                                          
/// Potential drawbacks:
/// - If you’re never consuming dimensions for UI or metadata, then it’s just duplication.
/// - It may end up being a weakly typed, stringly-coded “units system” (because .degrees isn’t actually an Angle).

//public enum EffectDimension: String, Identifiable, Documentable {
//  case degrees
//  case horizontal
//  case vertical
//  case count
//  case speed
//  case strength
//
//  public var id: String {
//    self.rawValue
//  }
//
//  public var name: String {
//    self.rawValue.capitalized
//  }
//
// public var icon: String {
//    switch self {
//      case .degrees: "angle"
//      case .horizontal: "arrow.left.and.right"  // "arrow.left.and.right.square"
//      case .vertical: "arrow.up.and.down"  // "arrow.up.and.down.square"
//      case .count: "numbers"  // waveform.path.ecg
//      case .speed: "hare"
//      case .strength: "dial.high.fill"
//    }
//  }
//}
