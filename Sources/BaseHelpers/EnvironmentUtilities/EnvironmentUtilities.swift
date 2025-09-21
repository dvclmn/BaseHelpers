//
//  EnvironmentUtilities.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 24/6/2025.
//

import SwiftUI

extension EnvironmentValues {

  /// This is expected to represent a single, self-contained View,
  /// not including any native components like Toolbar or Inspector.
  ///
  /// I guess like in a graphics app, so maybe this is a bit domain-specific
  @Entry public var viewportSize: CGSize? = nil

  @Entry public var isPreviewOnlyDebugMode: Bool = false

  @Entry public var isEmphasised: Bool = false
  @Entry public var isCompactMode: Bool = false
  @Entry public var isConnectedToInternet: Bool = false
  @Entry public var isScrollAtStart: Bool = true

}

/// Where `1.0` is original size, and reduction goes down from there
public enum ReductionStrength: CGFloat {
  case weeBit = 0.95
  case slight = 0.85
  case moderate = 0.7
  case standard = 0.6
  case strong = 0.45
  case veryStrong = 0.3
}

extension Bool {
  public func compact<T: BinaryFloatingPoint>(
    _ value: T,
    by strength: ReductionStrength = .standard
  ) -> T {
    let reduced = value * T(strength.rawValue)
    return self ? reduced : value
  }
}

//extension BinaryFloatingPoint {
//  public func compacted(
//    _ isCompact: Bool,
//    strength: ReductionStrength
//  ) -> Self {
//    return isCompact ? self * Self(strength.rawValue) : self
//  }
//}
