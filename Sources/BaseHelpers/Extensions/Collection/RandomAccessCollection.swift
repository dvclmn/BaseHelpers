//
//  RandomAccessCollection.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 28/9/2025.
//

import Foundation

extension RandomAccessCollection where Element: Equatable, Index == Int {

  public func element(after index: Int, wrapping: Bool = true) -> Element? {
    guard !isEmpty,
      let targetIndex = nextIndex(after: index, wrapping: wrapping)
    else { return nil }
    return self[targetIndex]
  }

  public func element(before index: Int, wrapping: Bool = true) -> Element? {
    guard !isEmpty,
      let targetIndex = previousIndex(before: index, wrapping: wrapping)
    else { return nil }
    return self[targetIndex]
  }
  
  public func nextElement(after element: Element, wrapping: Bool = true) -> Element? {
    guard let i = firstIndex(of: element) else { return nil }
    return self.element(after: i, wrapping: wrapping)
  }

  public func previousElement(before element: Element, wrapping: Bool = true) -> Element? {
    guard let i = firstIndex(of: element) else { return nil }
    return self.element(before: i, wrapping: wrapping)
  }
}
