//
//  Alignment.swift
//  Collection
//
//  Created by Dave Coleman on 20/12/2024.
//

import SwiftUI

/// Good to remember: `Alignment` always describes
/// *two* things; a `HorizontalAlignment` *and*
/// a `VerticalAlignment`. It is not one or the other,
/// it is a composite of both.
extension Alignment {

  public var toTextAlignment: TextAlignment {
    switch self {
      case .topLeading, .bottomLeading, .leading: .leading
      case .topTrailing, .bottomTrailing, .trailing: .trailing
      case .center: .center
      default: .leading
    }
  }

  /// Returns a sensible corresponding `UnitPoint`, with optional
  /// fallback. Text baseline alignments are ignored and use the fallback.
  public func toUnitPoint(fallback: UnitPoint = .center) -> UnitPoint {

    switch self {
//      case .topLeading: .topLeading
//      case .top: .top
//      case .topTrailing: .topTrailing
//      case .trailing: .trailing
//      case .bottomTrailing: .bottomTrailing
//      case .bottom: .bottom
//      case .bottomLeading: .bottomLeading
//      case .leading: .leading
////      case .center: .center
//        
//      case .center:
      case .leading: .leading
      case .trailing: .trailing
      case .top: .top
      case .bottom: .bottom
      case .topLeading: .topLeading
      case .topTrailing: .topTrailing
      case .bottomLeading: .bottomLeading
      case .bottomTrailing: .bottomTrailing
//      case .centerFirstTextBaseline: .leading
//      case .centerLastTextBaseline: .leading
//      case .leadingFirstTextBaseline: .leading
//      case .leadingLastTextBaseline: .leading
//      case .trailingFirstTextBaseline: .leading
//      case .trailingLastTextBaseline: .leading
        
      default: fallback
    }
  }

  public var displayName: (abbreviated: String, standard: String, full: String) {
    switch self {
      case .top:
        return ("Top", "Top", "Top (H: Center + V: Top)")

      case .topLeading:
        return ("T.Lead", "Top Leading", "Top Leading (H: Leading + V: Top)")

      case .topTrailing:
        return ("T.Trail", "Top Trailing", "Top Trailing (H: Trailing + V: Top)")

      case .bottom:
        return ("Bottom", "Bottom", "Bottom (H: Center + V: Bottom)")

      case .bottomLeading:
        return ("B.Lead", "Bottom Leading", "Bottom Leading (H: Leading + V: Bottom)")

      case .bottomTrailing:
        return ("B.Trail", "Bottom Trailing", "Bottom Trailing (H: Trailing + V: Bottom)")

      case .center:
        return ("Cent.", "Center", "Center (H: Center + V: Center)")

      case .centerFirstTextBaseline:
        return (
          "Cent.FTB", "Center First Text Baseline", "Center First Text Baseline (H: Center + V: FirstTextBaseline)"
        )

      case .centerLastTextBaseline:
        return ("Cent.LTB", "Center Last Text Baseline", "Center Last Text Baseline (H: Center + V: LastTextBaseline)")

      case .leading:
        return ("Lead", "Leading", "Leading (H: Leading + V: Center)")

      case .leadingFirstTextBaseline:
        return (
          "Lead.FTB", "Leading First Text Baseline", "Leading First Text Baseline (H: Leading + V: FirstTextBaseline)"
        )

      case .leadingLastTextBaseline:
        return (
          "Lead.LTB", "Leading Last Text Baseline", "Leading Last Text Baseline (H: Leading + V: LastTextBaseline)"
        )

      case .trailing:
        return ("Trail.", "Trailing", "Trailing (H: Trailing + V: Center)")

      case .trailingFirstTextBaseline:
        return (
          "Trail.FTB", "Trailing First Text Baseline",
          "Trailing First Text Baseline (H: Trailing + V: FirstTextBaseline)"
        )

      case .trailingLastTextBaseline:
        return (
          "Trail.LTB", "Trailing Last Text Baseline", "Trailing Last Text Baseline (H: Trailing + V: LastTextBaseline)"
        )

      default:
        return ("Unknown", "Unknown", "Unknown")
    }
  }

  public var opposite: Alignment {
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

  /// Returns `.center` as default if case is unknown
  public var opposite: HorizontalAlignment {
    switch self {
      case .leading: .trailing
      case .trailing: .leading
      case .listRowSeparatorLeading: .listRowSeparatorTrailing
      case .listRowSeparatorTrailing: .listRowSeparatorLeading
      default: .center
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
  /// Returns `.center` as default if case is unknown
  public var opposite: VerticalAlignment {
    switch self {
      case .top: .bottom
      case .bottom: .top
      case .firstTextBaseline: .lastTextBaseline
      case .lastTextBaseline: .firstTextBaseline
      default: .center
    }
  }
}
