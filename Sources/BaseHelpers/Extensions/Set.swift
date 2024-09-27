//
//  Set.swift
//  Collection
//
//  Created by Dave Coleman on 26/9/2024.
//

import Foundation


public extension Set {
  var array: [Element] {
    Array(self)
  }
}


public extension Set {
  enum SelectionPosition {
    case single
    case first
    case middle
    case last
    case notSelected
  }
  
  func selectionPosition<ID: Hashable>(
    for id: ID,
    idForElement: (Element) -> ID,
    in sortedIDs: [ID],
    isPreviousSelected: (ID) -> Bool,
    isNextSelected: (ID) -> Bool
  ) -> SelectionPosition {
    guard self.contains(where: { idForElement($0) == id }) else { return .notSelected }
    
    guard let currentIndex = sortedIDs.firstIndex(of: id) else { return .notSelected }
    
    let previousSelected = currentIndex > 0 ? isPreviousSelected(sortedIDs[currentIndex - 1]) : false
    let nextSelected = currentIndex < sortedIDs.count - 1 ? isNextSelected(sortedIDs[currentIndex + 1]) : false
    
    switch (previousSelected, nextSelected) {
      case (false, false):
        return .single
      case (false, true):
        return .first
      case (true, false):
        return .last
      case (true, true):
        return .middle
    }
  }
}










