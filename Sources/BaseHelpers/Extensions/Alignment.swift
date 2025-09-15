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

  public var displayName: (abbreviated: String, standard: String, full: String) {
    switch self {
      case .top:
        return ("Top", "Top", "Top (H: Center + V: Top)")

      case .topLeading:
        return ("T.Leading", "Top Leading", "Top Leading (H: Leading + V: Top)")

      case .topTrailing:
        return ("Top Trailing", "Top Trailing", "Top Trailing (H: Trailing + V: Top)")

      case .bottom:
        return ("Bottom", "Bottom", "Bottom (H: Center + V: Bottom)")

      case .bottomLeading:
        return ("Bottom Leading", "Bottom Leading", "Bottom Leading (H: Leading + V: Bottom)")

      case .bottomTrailing:
        return ("Bottom Trailing", "Bottom Trailing", "Bottom Trailing (H: Trailing + V: Bottom)")

      case .center:
        return ("Center", "Center", "Center (H: Center + V: Center)")

      case .centerFirstTextBaseline:
        return ("Center First Text Baseline", "Center First Text Baseline", "Center First Text Baseline (H: Center + V: FirstTextBaseline)")

      case .centerLastTextBaseline:
        return ("Center Last Text Baseline", "Center Last Text Baseline", "Center Last Text Baseline (H: Center + V: LastTextBaseline)")

      case .leading:
        return ("Leading", "Leading", "Leading (H: Leading + V: Center)")

      case .leadingFirstTextBaseline:
        return ("Leading First Text Baseline", "Leading First Text Baseline", "Leading First Text Baseline (H: Leading + V: FirstTextBaseline)")

      case .leadingLastTextBaseline:
        return ("Leading Last Text Baseline", "Leading Last Text Baseline", "Leading Last Text Baseline (H: Leading + V: LastTextBaseline)")

      case .trailing:
        return ("Trailing", "Trailing", "Trailing (H: Trailing + V: Center)")

      case .trailingFirstTextBaseline:
        return ("Trailing First Text Baseline", "Trailing First Text Baseline", "Trailing First Text Baseline (H: Trailing + V: FirstTextBaseline)")

      case .trailingLastTextBaseline:
        return ("Trailing Last Text Baseline", "Trailing Last Text Baseline", "Trailing Last Text Baseline (H: Trailing + V: LastTextBaseline)")

      default:
        return ("Unknown", "Unknown", "Unknown")
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
extension VerticalAlignment {
  public var displayName: String {
    switch self {
      case .bottom: "Bottom"
      case .center: "Center"
      case .top: "Top"
      case .firstTextBaseline: "First Text Baseline"
      case .lastTextBaseline: "Last Text Baseline"
      default: "Unknown"
    }
  }
}
