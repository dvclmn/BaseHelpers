//
//  RandomAccessCollection.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 28/9/2025.
//

import Foundation

extension RandomAccessCollection where Index == Int {
  
  // Reuse the index calculation logic from Collection
  public func element(after index: Int, wrapping: Bool = true) -> Element? {
    guard !isEmpty, let targetIndex = nextIndex(after: index, wrapping: wrapping) else {
      return nil
    }
    return self[targetIndex]
  }
  
  public func element(before index: Int, wrapping: Bool = true) -> Element? {
    guard !isEmpty, let targetIndex = previousIndex(before: index, wrapping: wrapping) else {
      return nil
    }
    return self[targetIndex]
  }
}
