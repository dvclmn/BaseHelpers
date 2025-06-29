//
//  Comparable.swift
//  Helpers
//
//  Created by Dave Coleman on 31/8/2024.
//

import Foundation

extension Comparable {

  /// Returns `self` clamped to the provided range.
  /// - Precondition: The range must be valid (i.e., lowerBound <= upperBound).
  /// Note: This is *not* the same as normalising
  public func clamped(to range: ClosedRange<Self>) -> Self {
    return clamped(range.lowerBound, range.upperBound)
  }
  
  
  
//  func clamped(to range: ClosedRange<Self>) -> Self {
//    min(max(self, range.lowerBound), range.upperBound)
//  }
  
  public func clamped(_ lowerBound: Self, _ upperBound: Self) -> Self {
    precondition(lowerBound <= upperBound, "Invalid range: lowerBound must be less than or equal to upperBound.")
    return min(max(self, lowerBound), upperBound)
  }
  
//  public func constrained(_ atLeast: Self, _ atMost: Self) -> Self {
//    return min(max(self, atLeast), atMost)
//  }
//
//  public func clamped(to range: ClosedRange<Self>) -> Self {
//    let validRange = min(range.lowerBound, range.upperBound)...max(range.lowerBound, range.upperBound)
//    return min(max(self, validRange.lowerBound), validRange.upperBound)
//  }
}

extension Comparable where Self: BinaryFloatingPoint {
  
  /// Returns `self` clamped to the provided range, or `nil` if either bound is not finite.
  /// - Precondition: The range must be valid (i.e., lowerBound <= upperBound).
  public func clampedIfFinite(to range: ClosedRange<Self>) -> Self? {
    precondition(range.lowerBound <= range.upperBound, "Invalid range: lowerBound must be less than or equal to upperBound.")
    guard range.lowerBound.isFinite, range.upperBound.isFinite else { return nil }
    return min(max(self, range.lowerBound), range.upperBound)
  }
  
  /// Normalises `self` as a percentage (0 to 100) within the given source range.
  /// - Returns: A linear percentage (not clamped).
  /// - Precondition: The range must be valid (i.e., lowerBound < upperBound).
  public func normalised(from range: ClosedRange<Self>) -> Self {
    precondition(range.lowerBound < range.upperBound, "Invalid range: lowerBound must be less than upperBound.")
    return (self - range.lowerBound) / (range.upperBound - range.lowerBound) * 100
  }
  
  /// Normalises `self` as a clamped percentage (0 to 100) within the given source range.
  /// - Returns: Value is first clamped to range, then normalised.
  /// - Precondition: The range must be valid (i.e., lowerBound < upperBound).
  public func normalisedClamped(from range: ClosedRange<Self>) -> Self {
    precondition(range.lowerBound < range.upperBound, "Invalid range: lowerBound must be less than upperBound.")
    let clampedSelf = self.clamped(to: range)
    return (clampedSelf - range.lowerBound) / (range.upperBound - range.lowerBound) * 100
  }
  
//  public func clampedAndFinite(to range: ClosedRange<Self>) -> Self? {
//    
//    let minValue = min(range.lowerBound, range.upperBound)
//    let maxValue = max(range.lowerBound, range.upperBound)
//    
//    let validRange = minValue...maxValue
//    
//    guard validRange.lowerBound.isFinite && validRange.upperBound.isFinite else { return nil }
//    let result = min(max(self, validRange.lowerBound), validRange.upperBound)
//    return result
//  }
//
//  public func normalised(from originalRange: (min: Self, max: Self)) -> Self {
//    guard originalRange.min < originalRange.max else { return self }
//    return (self - originalRange.min) / (originalRange.max - originalRange.min) * 100
//  }
}
