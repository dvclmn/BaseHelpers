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
  
  @Entry public var isDebugMode: Bool = false

  @Entry public var isEmphasised: Bool = false
  @Entry public var isCompactMode: Bool = false

}

public enum CompactReductionStrength: CGFloat {
  case slight = 0.95
  case moderate = 0.85
  case standard = 0.7
  case something = 0.6
  case strong = 0.45
}

extension Bool {
  public func compacted<T: BinaryFloatingPoint>(
    _ value: T,
//    _ isCompact: Bool,
    strength: CompactReductionStrength
  ) -> T {
    return self ? (value * T(strength.rawValue)) : value
  }
}

extension BinaryFloatingPoint {
  public func compacted(
    _ isCompact: Bool,
    strength: CompactReductionStrength
  ) -> Self {
    return isCompact ? self * Self(strength.rawValue) : self
  }
}
