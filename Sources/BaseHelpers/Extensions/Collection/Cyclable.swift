//
//  Cyclable.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 31/8/2025.
//

import Foundation

public protocol Cyclable: LabeledItem {
  static var defaultCase: Self { get }
}

//extension Cyclable where
//Self: CaseIterable & Equatable,
//AllCases: RandomAccessCollection,
//AllCases.Index == Int
//{
extension Cyclable
where
  Self: CaseIterable,
  Self.AllCases: RandomAccessCollection,
  Self.AllCases.Index == Int
{
  //  private static var all: AllCases { allCases }

  public var isAtBeginning: Bool { self == Self.allCases.first }
  public var isAtEnd: Bool { self == Self.allCases.last }

  public func toNext(wrapping: Bool = true) -> Self {
    //    Self.allCases.element(after: i, wrapping: wrapping)
    Self.allCases.nextElement(after: self, wrapping: wrapping) ?? Self.defaultCase
  }

  public func toPrevious(wrapping: Bool = true) -> Self {
    Self.allCases.previousElement(before: self, wrapping: wrapping) ?? Self.defaultCase
  }

  public mutating func moveForward(wrapping: Bool = true) { self = toNext(wrapping: wrapping) }
  public mutating func moveBackward(wrapping: Bool = true) { self = toPrevious(wrapping: wrapping) }

  public mutating func toggle() {
    precondition(Self.allCases.count == 2, "toggle() requires exactly two cases")
    self = toNext()  // wrapping is fine: only 2 elements
  }
}

//extension Cyclable where Self.AllCases.Index == Int, Self: CaseIterable, Self.AllCases: RandomAccessCollection {
//
//  public var isAtBeginning: Bool { self == Self.allCases.first }
//  public var isAtEnd: Bool { self == Self.allCases.last }
//
//  public func toNext(wrapping: Bool = true) -> Self {
//    let all = Self.allCases
//    guard
//      let current = all.firstIndex(of: self),
//      let next = CyclicIndex.next(
//        current: current,
//        count: all.count,
//        wrapping: wrapping
//      )
//    else { return Self.defaultItem }
//    return all[next]
//  }
//
//  public func toPrevious(wrapping: Bool = true) -> Self {
//    let all = Self.allCases
//    guard
//      let current = all.firstIndex(of: self),
//      let prev = CyclicIndex.previous(
//        current: current,
//        count: all.count,
//        wrapping: wrapping
//      )
//    else { return Self.defaultItem }
//    return all[prev]
//  }
//
//  /// Useful for in-place mutation, allow more concise usage, e.g.:
//  /// `modeHandler.currentMode.cycleForward()`
//  public mutating func moveForward(wrapping: Bool = true) {
//    self = toNext(wrapping: wrapping)
//  }
//
//  public mutating func moveBackward(wrapping: Bool = true) {
//    self = toPrevious(wrapping: wrapping)
//  }
//
//  /// A toggle method, only available for two-case enums
//  public mutating func toggle() {
//    precondition(Self.allCases.count == 2, "toggle() is only valid for two-case enums")
//    self = toNext(wrapping: true)
//  }
//
//}

//extension Cyclable where Self: Collection {
//  /// Clamped here means returns the same case, when reaching
//  /// an edge, if wrapping is set to false
//  ///
//  /// Suitable for enums, such as `Cyclable`
//  public func nextIndexClamped(after index: Int, wrapping: Bool = true) -> Int {
//    guard !isEmpty else { return 0 }
//    let nextIdx = index + 1
//    guard wrapping else {
//      return Swift.min(nextIdx, count - 1)  // Clamp to last index
//    }
//    return nextIdx % count
//  }
//
//  public func previousIndexClamped(before index: Int, wrapping: Bool = true) -> Int {
//    guard !isEmpty else { return 0 }
//    let prevIdx = index - 1
//    guard wrapping else {
//      return Swift.max(prevIdx, 0)  // Clamp to first index
//    }
//    return (prevIdx + count) % count
//  }
//
//}
