//
//  Cyclable.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 31/8/2025.
//

import Foundation

public protocol Cyclable: LabeledItem
where
  Self: CaseIterable,
  Self.AllCases: RandomAccessCollection,
  Self.AllCases.Index == Int
{
  static var defaultCase: Self { get }
}

extension Cyclable {
  public var isAtBeginning: Bool { self == Self.allCases.first }
  public var isAtEnd: Bool { self == Self.allCases.last }

  public func toNext(wrapping: Bool = true) -> Self {
    Self.allCases.nextElement(after: self, wrapping: wrapping) ?? Self.defaultCase
  }

  public func toPrevious(wrapping: Bool = true) -> Self {
    Self.allCases.previousElement(before: self, wrapping: wrapping) ?? Self.defaultCase
  }

  public mutating func moveForward(wrapping: Bool = true) {
    self = toNext(wrapping: wrapping)
  }
  public mutating func moveBackward(wrapping: Bool = true) {
    self = toPrevious(wrapping: wrapping)
  }

  public mutating func toggle() {
    precondition(Self.allCases.count == 2, "toggle() requires exactly two cases")
    self = toNext()  // wrapping is fine: only 2 elements
  }
}
