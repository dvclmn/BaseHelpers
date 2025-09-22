//
//  Model+ViewMode.swift
//  BaseComponents
//
//  Created by Dave Coleman on 3/7/2025.
//

import SwiftUI

/// I think I stopped using this otherwise-helpful type, as I think
/// it resulted in unintentionally setting other properties, when
/// only wanting to set 'x' property. Like wanting to set a view
/// to `debug` mode, but the defaults for `compact` and
/// `emphasised` also being set?
public struct ViewModes: OptionSet, Sendable {
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
  public let rawValue: Int

  public static let compact = Self(rawValue: 1 << 0)
  public static let debug = Self(rawValue: 1 << 1)
  public static let emphasised = Self(rawValue: 1 << 2)
}

extension ViewModes: CustomStringConvertible {
  /// Add a static collection of all cases
  private static let allCases: [(mode: Self, name: String)] = [
    (.compact, "compact"),
    (.debug, "debug"),
    (.emphasised, "emphasised"),
  ]

  public var description: String {
    let names = Self.allCases
      .compactMap { (mode, name) in
        self.contains(mode) ? name : nil
      }
    if names.isEmpty { return "[]" }
    return "ViewModes(\(names.joined(separator: ", ")))"
  }

}

public struct ViewModesModifier: ViewModifier {
  @Environment(\.viewModes) private var existingModes

  let newModes: ViewModes
  public func body(content: Content) -> some View {
    content.environment(\.viewModes, existingModes.union(newModes))
  }
}

extension View {
  public func setViewModes(_ modes: ViewModes) -> some View {
    self.modifier(ViewModesModifier(newModes: modes))
  }
}
