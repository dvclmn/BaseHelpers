//
//  Compat+Toolbar.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/9/2025.
//

import SwiftUI

extension View {
  @ViewBuilder
  public func toolbarBackgroundVisibilityCompat(
    _ visibility: Visibility,
    isForWindowToolbar: Bool,
//  for bars: ToolbarPlacement...
  ) -> some View {
    if #available(macOS 15.0, iOS 18.0, *) {
      self.toolbarBackgroundVisibility(visibility, for: isForWindowToolbar ? .windowToolbar : .automatic)
    } else {
      self
    }
  }
}
