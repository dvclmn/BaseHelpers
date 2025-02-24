//
//  Array.swift
//  Helpers
//
//  Created by Dave Coleman on 31/8/2024.
//

extension Array where Element: Equatable {
  
  public func indexOf(_ item: Element?) -> Int? {
    guard let item = item else { return nil }
    return self.firstIndex(of: item)
  }

  public func nextIndex(after item: Element?) -> Int? {
    guard let currentIndex = self.indexOf(item) else { return nil }
    let nextIndex = currentIndex + 1
    return nextIndex < self.count ? nextIndex : nil
  }

  public func previousIndex(before item: Element?) -> Int? {
    guard let currentIndex = self.indexOf(item) else { return nil }
    let previousIndex = currentIndex - 1
    return previousIndex >= 0 ? previousIndex : nil
  }

  public func secondToLast() -> Element? {
    if self.count < 2 {
      return nil
    }
    let index = self.count - 2
    return self[index]
  }
}
