//
//  Model+Dimension.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/8/2025.
//

import Foundation

public enum EffectDimension: String, Identifiable, Documentable {
  case degrees
  case horizontal
  case vertical
  case count
  case speed
  case strength

  public var id: String {
    self.rawValue
  }

  public var name: String {
    self.rawValue.capitalized
  }

 public var icon: String {
    switch self {
      case .degrees: "angle"
      case .horizontal: "arrow.left.and.right"  // "arrow.left.and.right.square"
      case .vertical: "arrow.up.and.down"  // "arrow.up.and.down.square"
      case .count: "numbers"  // waveform.path.ecg
      case .speed: "hare"
      case .strength: "dial.high.fill"
    }
  }
}
