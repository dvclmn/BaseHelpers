//
//  RandomAccessCollection.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 28/9/2025.
//

import Foundation

extension RandomAccessCollection where Element: Equatable, Index == Int {

  public func nextElement(
    after element: Element,
    wrapping: Bool = true
  ) -> Element? {
    guard !isEmpty,
      let i = firstIndex(of: element),
      let targetIndex = nextIndex(after: i, wrapping: wrapping)
    else { return nil }

    return self[targetIndex]
  }

  public func previousElement(
    before element: Element,
    wrapping: Bool = true
  ) -> Element? {

    guard !isEmpty,
      let i = firstIndex(of: element),
      let targetIndex = previousIndex(before: i, wrapping: wrapping)
    else { return nil }

    return self[targetIndex]
  }
}
