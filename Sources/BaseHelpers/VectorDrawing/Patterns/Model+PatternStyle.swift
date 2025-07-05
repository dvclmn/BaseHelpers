//
//  Model+PatternStyle.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import Foundation

public enum PatternStyle: CaseIterable, Identifiable, Codable, Sendable {
  case checkerboard
  case chevron
  case stitches
  case waves
  case stripes
  
  public var id: String {
    self.name
  }
  
  public var name: String {
    switch self {
      case .checkerboard: "Checkerboard"
      case .chevron: "Chevron"
      case .stitches: "Stitches"
      case .waves: "Waves"
      case .stripes: "Stripes"
    }
  }
}
