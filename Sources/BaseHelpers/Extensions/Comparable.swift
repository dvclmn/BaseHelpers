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

  /// `min` == `lowerBound`
  /// `max` == `upperBound`
  public func clamped(_ min: Self, _ max: Self) -> Self {
    return Swift.min(max, Swift.max(min, self))
  }

  public func clamped(_ min: Self) -> Self {
    return Swift.max(min, self)
  }

}

extension Comparable where Self: BinaryFloatingPoint {

  public func clamped(toIntRange range: Range<Int>) -> Self {
    return clamped(Self(range.lowerBound), Self(range.upperBound))
  }

  /// Returns `self` clamped to the provided range, or `nil` if either bound is not finite.
  /// - Precondition: The range must be valid (i.e., lowerBound <= upperBound).
  public func clampedIfFinite(to range: ClosedRange<Self>) -> Self? {
    precondition(
      range.lowerBound <= range.upperBound, "Invalid range: lowerBound must be less than or equal to upperBound.")
    guard range.lowerBound.isFinite, range.upperBound.isFinite else { return nil }
    return min(max(self, range.lowerBound), range.upperBound)
  }

  /// Re the below: I realised that these are multiplying by `100`, which is a pretty
  /// huge assumption, and not communicated in the method name at all.
  /// I have switched these off for now, and will likely remove later.
  //  /// Normalises `self` as a percentage (0 to 100) within the given source range.
  //  /// - Returns: A linear percentage (not clamped).
  //  /// - Precondition: The range must be valid (i.e.,`lowerBound < upperBound`).
  //  public func normalised(from range: ClosedRange<Self>) -> Self {
  //    precondition(range.lowerBound < range.upperBound, "Invalid range: lowerBound must be less than upperBound.")
  //    return (self - range.lowerBound) / (range.upperBound - range.lowerBound) * 100
  //  }
  //
  //  /// Normalises `self` as a clamped percentage (0 to 100) within the given source range.
  //  /// - Returns: Value is first clamped to range, then normalised.
  //  /// - Precondition: The range must be valid (i.e., lowerBound < upperBound).
  //  public func normalisedClamped(from range: ClosedRange<Self>) -> Self {
  //    precondition(range.lowerBound < range.upperBound, "Invalid range: lowerBound must be less than upperBound.")
  //    let clampedSelf = self.clamped(to: range)
  //    return (clampedSelf - range.lowerBound) / (range.upperBound - range.lowerBound) * 100
  //  }

}
