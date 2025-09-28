//
//  Collection.swift
//  Collection
//
//  Created by Dave Coleman on 17/12/2024.
//

extension Collection {
  
  public func hasIndex(_ offset: Int) -> Bool {
    let startIndex = self.startIndex
    let endIndex = self.endIndex
    guard let index = self.index(startIndex, offsetBy: offset, limitedBy: endIndex) else {
      return false
    }
    return index < endIndex
  }
  
  public var toArray: [Element] {
    return Array(self)
  }
}

extension Collection where Index == Int {

  /// Core index calculation logic - reusable across different collection types
  public func nextIndex(
    after index: Int,
    wrapping: Bool = true
  ) -> Int? {
    let nextIdx = index + 1
    guard wrapping else {
      return nextIdx < count ? nextIdx : nil
    }
    return nextIdx % count
  }
  
  public func previousIndex(
    before index: Int,
    wrapping: Bool = true
  ) -> Int? {
    let prevIdx = index - 1
    guard wrapping else {
      return prevIdx >= 0 ? prevIdx : nil
    }
    return (prevIdx + count) % count
  }
}
