//
//  Hashable.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 7/9/2025.
//

import Foundation

extension Hashable {
  /// Given the ID of the right-clicked item, returns the IDs to act upon.
  ///
  /// This came about when writing context menu logic in SwiftUI for
  /// a single item, and thinking about how other items being selected
  /// should affect this — including whether the clicked item is
  /// *part of* this selection.
  public func itemsForContextMenuAction(
    selected: Set<Self>
  ) -> [Self] {
    guard !selected.isEmpty else {
      /// nothing selected → just clicked item
      return [self]
    }
    
    if selected.contains(self) {
      /// clicked inside selection → all selected
      return Array(selected)
      
    } else {
      /// clicked outside selection → just clicked item
      return [self]
    }
  }
}
