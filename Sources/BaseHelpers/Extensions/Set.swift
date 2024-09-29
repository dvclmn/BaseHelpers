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

public enum SelectionPosition {
  case single
  case top
  case middle
  case bottom
}

extension Set where Element: Hashable {
  public func selectionPosition<T: Hashable>(
    for id: Element,
    idForElement: (T) -> Element,
    in sortedElements: [T],
    isPreviousSelected: (Element) -> Bool,
    isNextSelected: (Element) -> Bool
  ) -> SelectionPosition? {
    guard self.contains(id) else { return nil }
    
    guard let index = sortedElements.firstIndex(where: { idForElement($0) == id }) else {
      return .single
    }
    
    let previousSelected = index > 0 ? isPreviousSelected(idForElement(sortedElements[index - 1])) : false
    let nextSelected = index < sortedElements.count - 1 ? isNextSelected(idForElement(sortedElements[index + 1])) : false
    
    switch (previousSelected, nextSelected) {
      case (false, false): return .single
      case (true, false): return .bottom
      case (false, true): return .top
      case (true, true): return .middle
    }
  }
}









