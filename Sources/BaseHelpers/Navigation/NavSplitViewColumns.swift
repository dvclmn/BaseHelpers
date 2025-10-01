//
//  NavSplitViewColumns.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/9/2025.
//

import SwiftUI
extension NavigationSplitViewVisibility {
  public var isSidebarVisible: Bool {
    self != .detailOnly && self != .doubleColumn
  }
}
