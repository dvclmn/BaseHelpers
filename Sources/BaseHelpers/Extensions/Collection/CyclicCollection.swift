//
//  CyclicCollection.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/9/2025.
//

import Foundation

extension Array: CyclicCollection {}

/// Anything that can move forwards/backwards through its elements.
public protocol CyclicCollection: RandomAccessCollection where Index == Int {
  /// Returns the element at `index` advanced by one step.
  func element(after index: Int, wrapping: Bool) -> Element?
  func element(before index: Int, wrapping: Bool) -> Element?
}

//public protocol CyclicCollection {
//  associatedtype Element
//  var elements: [Element] { get }
//  var currentIndex: Int? { get }
//  mutating func setCurrentIndex(_ index: Int?)
//}

//extension RandomAccessCollection where Index == Int {
//  public func element(after index: Int, wrapping: Bool = true) -> Element? {
//    guard !isEmpty else { return nil }
//    let next = index + 1
//    let target = wrapping ? next % count : (next < count ? next : index)
//    return self[target]
//  }
//
//  public func element(before index: Int, wrapping: Bool = true) -> Element? {
//    guard !isEmpty else { return nil }
//    let prev = index - 1
//    let target = wrapping ? (prev + count) % count : (prev >= 0 ? prev : index)
//    return self[target]
//  }
//}

extension CyclicCollection where Element: Equatable {
  public func nextElement(after element: Element, wrapping: Bool = true) -> Element? {
    guard let i = firstIndex(of: element) else { return nil }
    return self.element(after: i, wrapping: wrapping)
  }
  
  public func previousElement(before element: Element, wrapping: Bool = true) -> Element? {
    guard let i = firstIndex(of: element) else { return nil }
    return self.element(before: i, wrapping: wrapping)
  }
}

//public struct CyclicIndex {
//  public static func next(
//    current: Int?, count: Int, wrapping: Bool = true
//  ) -> Int? {
//    guard count > 0 else { return nil }
//    guard let i = current else { return 0 }
//    let next = i + 1
//    return wrapping ? next % count : min(next, count - 1)
//  }
//
//  public static func previous(
//    current: Int?, count: Int, wrapping: Bool = true
//  ) -> Int? {
//    guard count > 0 else { return nil }
//    guard let i = current else { return count - 1 }
//    let prev = i - 1
//    return wrapping ? (prev + count) % count : max(prev, 0)
//  }
//}

//public protocol CyclicNavigator {
//  var collection: CyclicCollection { get }
//
//}
//extension CyclicNavigator {
//  public var isAtBeginning: Bool { self == Self.allCases.first }
//  public var isAtEnd: Bool { self == Self.allCases.last }
//}

public enum MoveDirection {
  case next
  case previous
}
