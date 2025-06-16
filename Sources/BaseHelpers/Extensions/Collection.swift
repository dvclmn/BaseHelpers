//
//  Collection.swift
//  Collection
//
//  Created by Dave Coleman on 17/12/2024.
//

extension Collection {
  //  func hasIndex(_ index: Int) -> Bool {
  //    self.indices.contains(index)
  //  }

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

  /// Clamped here means returns the same case, when reaching
  /// an edge, if wrapping is set to false
  ///
  /// Suitable for enums, such as `Cyclable`
  public func nextIndexClamped(after index: Int, wrapping: Bool = true) -> Int {
    guard !isEmpty else { return 0 }
    let nextIdx = index + 1
    guard wrapping else {
      return Swift.min(nextIdx, count - 1)  // Clamp to last index
    }
    return nextIdx % count
  }

  public func previousIndexClamped(before index: Int, wrapping: Bool = true) -> Int {
    guard !isEmpty else { return 0 }
    let prevIdx = index - 1
    guard wrapping else {
      return Swift.max(prevIdx, 0)  // Clamp to first index
    }
    return (prevIdx + count) % count
  }


}
