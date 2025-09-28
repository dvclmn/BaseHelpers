//
//  MoveDirection.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 28/9/2025.
//

import SwiftUI

public enum MoveDirection: String, Sendable, Equatable, Hashable, LabeledItem {
  case next
  case previous

  public var label: QuickLabel { QuickLabel(rawValue.capitalized, symbol: icon) }

  var icon: String {
    switch self {
      case .next: Icons.next.icon
      case .previous: Icons.previous.icon
    }
  }

  public func goTo<T>(
    current: T.Element,
    collection: T,
    wrapping: Bool = true
  ) -> T.Element? where T: RandomAccessCollection, T.Element: Equatable, T.Index == Int {
    switch self {
      case .next:
        collection.nextElement(
          after: current,
          wrapping: wrapping
        )
      case .previous:
        collection.previousElement(
          before: current,
          wrapping: wrapping
        )
    }
  }
  //  var shortcut: KeyboardShortcut? {
  //    switch self {
  //      case .next:
  //      case .previous:
  //    }
  //  }
}
