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
  
  /// This is handy to have, for basic needs, but at times I need
  /// more granualr control, so I should use `controlSize`
  /// for that I think
  @Entry public var isCompactMode: Bool = false
  
  @Entry public var isConnectedToInternet: Bool = false
  @Entry public var isScrollAtStart: Bool = true

}

//extension BinaryFloatingPoint {
//  public func compacted(
//    _ isCompact: Bool,
//    strength: ReductionStrength
//  ) -> Self {
//    return isCompact ? self * Self(strength.rawValue) : self
//  }
//}
