//
//  Array.swift
//  Helpers
//
//  Created by Dave Coleman on 31/8/2024.
//

public extension Set {
  var array: [Element] {
    Array(self)
  }
}


public extension Array where Element: Equatable {
  func indexOf(_ item: Element?) -> Int? {
    
    if let item = item {
      return self.firstIndex(of: item)
    } else {
      return nil
    }
  }
  
  func nextIndex(after item: Element?) -> Int? {
    guard let currentIndex = self.indexOf(item) else { return nil }
    let nextIndex = currentIndex + 1
    return nextIndex < self.count ? nextIndex : nil
  }
  
  func previousIndex(before item: Element?) -> Int? {
    guard let currentIndex = self.indexOf(item) else { return nil }
    let previousIndex = currentIndex - 1
    return previousIndex >= 0 ? previousIndex : nil
  }
  
  func secondToLast() -> Element? {
    if self.count < 2 {
      return nil
    }
    let index = self.count - 2
    return self[index]
  }
}

