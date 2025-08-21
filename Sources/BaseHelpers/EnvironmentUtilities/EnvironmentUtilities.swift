//
//  EnvironmentUtilities.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 24/6/2025.
//

import SwiftUI

//extension EnvironmentValues {
//  @Entry public var zoomLevel: CGFloat = 1.0
//  @Entry public var panOffset: CGSize = .zero
//}

extension EnvironmentValues {
  
  /// This is expected to represent be a single, self-contained View,
  /// not including any native components like Toolbar or Inspector.
  @Entry public var viewportSize: CGSize? = nil
  @Entry public var isDebugMode: Bool = false
  
  @Entry public var isEmphasised: Bool = false
  @Entry public var isCompactMode: Bool = false
  
}
