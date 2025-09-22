//
//  EnvironmentValues.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 22/9/2025.
//

import SwiftUI

extension EnvironmentValues {
  
  /// This is expected to represent a single, self-contained View,
  /// not including any native components like Toolbar or Inspector.
  ///
  /// I guess like in a graphics app, so maybe this is a bit domain-specific
  @Entry public var viewportSize: CGSize? = nil
  @Entry public var isConnectedToInternet: Bool = false
  @Entry public var isScrollAtStart: Bool = true
  
}
