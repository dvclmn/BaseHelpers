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

extension ToolbarContent {
  @ToolbarContentBuilder
  public func ToolbarSpacerCompatible(
    _ sizing: SpacerSizingCompatible = .flexible,
    placement: ToolbarItemPlacement = .automatic
  ) -> some ToolbarContent {
    if #available(macOS 26.0, *) {
      ToolbarSpacer(sizing.sizingCompatible, placement: placement)
    } else {
      ToolbarItem {
        Spacer()
      }
    }
  }
}

public enum SpacerSizingCompatible: Sendable {
  case flexible
  case fixed
}
@available(macOS 26.0, *)
extension SpacerSizingCompatible {
  public var sizingCompatible: SpacerSizing {
    switch self {
      case .flexible: .flexible
      case .fixed: .fixed
    }
  }
}
