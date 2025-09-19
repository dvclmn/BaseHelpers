//
//  CyclicCollection.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/9/2025.
//

import Foundation

public protocol CyclicCollection {
  associatedtype Element
  var elements: [Element] { get }
  var currentIndex: Int? { get }
  mutating func setCurrentIndex(_ index: Int?)
}

public struct CyclicIndex {
  public static func next(
    current: Int?, count: Int, wrapping: Bool = true
  ) -> Int? {
    guard count > 0 else { return nil }
    guard let i = current else { return 0 }
    let next = i + 1
    return wrapping ? next % count : min(next, count - 1)
  }

  public static func previous(
    current: Int?, count: Int, wrapping: Bool = true
  ) -> Int? {
    guard count > 0 else { return nil }
    guard let i = current else { return count - 1 }
    let prev = i - 1
    return wrapping ? (prev + count) % count : max(prev, 0)
  }
}

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
