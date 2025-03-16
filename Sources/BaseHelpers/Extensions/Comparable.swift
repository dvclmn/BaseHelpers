//
//  Comparable.swift
//  Helpers
//
//  Created by Dave Coleman on 31/8/2024.
//

import Foundation

extension Comparable {

  public func constrained(_ atLeast: Self, _ atMost: Self) -> Self {
    return min(max(self, atLeast), atMost)
  }

  public func clamped(to range: ClosedRange<Self>) -> Self {
    let validRange = min(range.lowerBound, range.upperBound)...max(range.lowerBound, range.upperBound)
    return min(max(self, validRange.lowerBound), validRange.upperBound)
  }

}

extension Comparable where Self: FloatingPoint {
  
  

  public func clampedAndFinite(to range: ClosedRange<Self>) -> Self? {
    let validRange = min(range.lowerBound, range.upperBound)...max(range.lowerBound, range.upperBound)
    guard validRange.lowerBound.isFinite && validRange.upperBound.isFinite else { return nil }
    return min(max(self, validRange.lowerBound), validRange.upperBound)
  }

  public func normalised(from originalRange: (min: Self, max: Self)) -> Self {
    guard originalRange.min < originalRange.max else { return self }
    return (self - originalRange.min) / (originalRange.max - originalRange.min) * 100
  }
}
