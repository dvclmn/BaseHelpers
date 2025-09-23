//
//  Model+SplineType.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/5/2025.
//

import Foundation

/// The type of Catmull-Rom parameterization to use
public enum CatmullRomType {
  case uniform      // Traditional tensor-based (fastest)
  case centripetal  // Best for natural drawing (recommended)
  case chordal      // Alternative parameterization
}
