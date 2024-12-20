//
//  Alignment.swift
//  Collection
//
//  Created by Dave Coleman on 20/12/2024.
//

import SwiftUI

public extension Alignment {

  var displayName: String {
    switch self {
      case .topLeading: "Top Leading"
      case .top: "Top"
      case .topTrailing: "Top Trailing"
      case .trailing: "Trailing"
      case .bottomTrailing: "Bottom Trailing"
      case .bottom: "Bottom"
      case .bottomLeading: "Bottom Leading"
      case .leading: "Leading"
      case .center: "Center"
      default:
        "Unknown"
    }
  }
}

public extension HorizontalAlignment {
  var displayName: String {
    switch self {
      case .leading: "Leading"
      case .center: "Center"
      case .trailing: "Trailing"
      case .listRowSeparatorLeading: "List Row Separator Leading"
      case .listRowSeparatorTrailing: "List Row Separator Trailing"

      default: "Unknown"
    }
  }
}
