//
//  Cyclable.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 31/8/2025.
//

import Foundation

public protocol Cyclable: LabeledItem where Self.AllCases.Index == Int {
//public protocol Cyclable: LabeledEnum where Self.AllCases.Index == Int {
  static var defaultCase: Self { get }
}



extension Cyclable {

//  public var isAtBeginning: Bool { self == Self.allCases.first }
//  public var isAtEnd: Bool { self == Self.allCases.last }

  public func toNext(wrapping: Bool = true) -> Self {
    let all = Self.allCases
    guard
      let current = all.firstIndex(of: self),
      let next = CyclicIndex.next(
        current: current,
        count: all.count,
        wrapping: wrapping
      )
    else { return Self.defaultCase }
    return all[next]
  }

  public func toPrevious(wrapping: Bool = true) -> Self {
    let all = Self.allCases
    guard
      let current = all.firstIndex(of: self),
      let prev = CyclicIndex.previous(
        current: current,
        count: all.count,
        wrapping: wrapping
      )
    else { return Self.defaultCase }
    return all[prev]
  }

  //  public func toNext(wrapping: Bool = true) -> Self {
  //    let allCases = Self.allCases
  //    guard let currentIndex: Int = allCases.firstIndex(of: self) else {
  //      return Self.defaultCase
  //    }
  //    let nextIndex: Int = allCases.nextIndexClamped(after: currentIndex, wrapping: wrapping)
  //    return allCases[nextIndex]
  //  }
  //
  //  public func toPrevious(wrapping: Bool = true) -> Self {
  //    let allCases = Self.allCases
  //    guard let currentIndex: Int = allCases.firstIndex(of: self) else {
  //      return Self.defaultCase
  //    }
  //    let prevIndex: Int = allCases.previousIndexClamped(before: currentIndex, wrapping: wrapping)
  //    return allCases[prevIndex]
  //  }

  /// Useful for in-place mutation, allow more concise usage, e.g.:
  /// `modeHandler.currentMode.cycleForward()`
  public mutating func moveForward(wrapping: Bool = true) {
    self = toNext(wrapping: wrapping)
  }

  public mutating func moveBackward(wrapping: Bool = true) {
    self = toPrevious(wrapping: wrapping)
  }

  /// A toggle method, only available for two-case enums
  public mutating func toggle() {
    precondition(Self.allCases.count == 2, "toggle() is only valid for two-case enums")
    self = toNext(wrapping: true)
  }
}

extension Collection {
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
