//
//  Angle.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/8/2025.
//

import SwiftUI

extension Angle {
  public static func * (lhs: Angle, rhs: CGFloat) -> Angle {
    Angle(radians: lhs.radians * Double(rhs))
  }
}
