//
//  Alignment.swift
//  Collection
//
//  Created by Dave Coleman on 20/12/2024.
//

import SwiftUI

extension Alignment {
  
  public var toTextAlignment: TextAlignment {
    switch self {
      case .topLeading, .bottomLeading, .leading: .leading
      case .topTrailing, .bottomTrailing, .trailing: .trailing
      case .center: .center
      default: .leading
    }
  }

  public var toUnitPoint: UnitPoint {

    switch self {
      case .topLeading: .topLeading
      case .top: .top
      case .topTrailing: .topTrailing
      case .trailing: .trailing
      case .bottomTrailing: .bottomTrailing
      case .bottom: .bottom
      case .bottomLeading: .bottomLeading
      case .leading: .leading
      case .center: .center
      default: .center
    }
  }


  public var displayName: String {
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
      default: "Unknown"
    }
  }

  public var opposing: Alignment {
    switch self {
      case .topLeading: .bottomTrailing
      case .top: .bottom
      case .topTrailing: .bottomLeading
      case .trailing: .leading
      case .bottomTrailing: .topLeading
      case .bottom: .top
      case .bottomLeading: .topTrailing
      case .leading: .trailing
      case .center: .center
      default: .center
    }
  }
}

extension HorizontalAlignment {
  public var displayName: String {
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
