//
//  ControlSize.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 21/9/2025.
//

import SwiftUI

extension ControlSize {
  public var scaleFactor: CGFloat {
    switch self {
      case .mini: 0.45
      case .small: 0.7
      case .regular: 1.0
      case .large: 1.15
      case .extraLarge: 1.3
      @unknown default: 1.0
    }
  }
}

public func scale(
  _ value: CGFloat,
  for controlSize: ControlSize,
  by strength: CGFloat = 1.0
) -> CGFloat {
  return value * controlSize.scaleFactor * strength
}


//extension Bool {
//  public func compact<T: BinaryFloatingPoint>(
//    _ value: T,
//    by strength: ReductionStrength = .standard
//  ) -> T {
//    let reduced = value * T(strength.rawValue)
//    return self ? reduced : value
//  }
//}
