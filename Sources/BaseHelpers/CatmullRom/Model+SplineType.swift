//
//  Model+SplineType.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/5/2025.
//

import Foundation

public enum CatmullRomType: Sendable, Codable {
  case uniform
  case chordal
  case centripetal
  
//  public var uniformTensionClamped: CGFloat {
//    return max(0, min(1, tension))
//  }
}
