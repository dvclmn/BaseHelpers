//
//  Comparable.swift
//  Helpers
//
//  Created by Dave Coleman on 31/8/2024.
//

public extension Comparable {
  func constrained(_ atLeast: Self, _ atMost: Self) -> Self {
    return min(max(self, atLeast), atMost)
  }
}

public extension Comparable where Self: FloatingPoint {
  func normalised(from originalRange: (min: Self, max: Self)) -> Self {
    guard originalRange.min < originalRange.max else { return self }
    return (self - originalRange.min) / (originalRange.max - originalRange.min) * 100
  }
}
